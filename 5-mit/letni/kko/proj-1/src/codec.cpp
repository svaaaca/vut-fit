/**
 * @file codec.cpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation file for image data compression and decompression functions.
 * @date 2026-05-03
 */

#include "codec.hpp"
#include <algorithm>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <sstream>

// ----------------------------------------
// --- COMPRESSION HEADER SERIALIZATION ---
// ----------------------------------------

std::vector<uint8_t> CompressionHeader::serialize() const {
    std::vector<uint8_t> result(11);

    // write magic number (big-endian)
    result[0] = (magic >> 24) & 0xFF;
    result[1] = (magic >> 16) & 0xFF;
    result[2] = (magic >> 8) & 0xFF;
    result[3] = magic & 0xFF;

    // write width (big-endian)
    result[4] = (width >> 8) & 0xFF;
    result[5] = width & 0xFF;

    // write height (big-endian)
    result[6] = (height >> 8) & 0xFF;
    result[7] = height & 0xFF;

    // write flags
    result[8] = flags;

    // write block size (big-endian)
    result[9] = (block_size >> 8) & 0xFF;
    result[10] = block_size & 0xFF;

    return result;
}

CompressionHeader CompressionHeader::deserialize(
    const std::vector<uint8_t> &data, size_t &offset) {
    if (offset + 11 > data.size()) {
        throw std::runtime_error("Nedostatek dat pro čtení hlavičky.\n");
    }

    CompressionHeader header;

    header.magic = ((uint32_t) data[offset] << 24) | ((uint32_t) data[offset + 1] << 16) | ((uint32_t) data[offset + 2] << 8) | ((uint32_t) data[offset + 3]);
    header.width = ((uint16_t) data[offset + 4] << 8) | data[offset + 5];
    header.height = ((uint16_t) data[offset + 6] << 8) | data[offset + 7];
    header.flags = data[offset + 8];
    header.block_size = ((uint16_t) data[offset + 9] << 8) | data[offset + 10];

    offset += 11;
    return header;
}

// ------------------------------------
// --- SCANNER MODULE - STATIC SCAN ---
// ------------------------------------

std::vector<uint8_t> static_scan(const uint8_t *image, int width, int height) {
    std::vector<uint8_t> result;
    int total_pixels = width * height;
    result.reserve(total_pixels);

    // simple left-to-right, top-to-bottom scan
    for (int i = 0; i < total_pixels; i++) {
        result.push_back(image[i]);
    }

    return result;
}

// --------------------------------------
// --- SCANNER MODULE - ADAPTIVE SCAN ---
// --------------------------------------

/**
 * @brief Extract rectangular block from image.
 * 
 * @param image Pointer to raw image data (grayscale, 1 byte per pixel).
 * @param img_width Image width in pixels.
 * @param img_height Image height in pixels.
 * @param block_x Block column index.
 * @param block_y Block row index.
 * @param block_size Block size in pixels (e.g., 16 for 16x16 blocks).
 * @return Extracted block data in row-major order.
 */
static std::vector<uint8_t> extract_block(const uint8_t *image, int img_width, int img_height, int block_x, int block_y, int block_size) {
    int block_w = std::min(block_size, img_width - block_x * block_size);
    int block_h = std::min(block_size, img_height - block_y * block_size);

    std::vector<uint8_t> block(block_w * block_h);

    for (int y = 0; y < block_h; y++) {
        int src_y = block_y * block_size + y;
        int src_x_start = block_x * block_size;
        std::memcpy(block.data() + y * block_w, image + src_y * img_width + src_x_start, block_w);
    }

    return block;
}

/**
 * @brief Transpose block (horizontal -> vertical scan).
 * 
 * @param block Input block data in row-major order.
 * @param block_w Block width in pixels.
 * @param block_h Block height in pixels.
 * @return Transposed block data in row-major order.
 */
static std::vector<uint8_t> transpose_block(const std::vector<uint8_t> &block, int block_w, int block_h) {
    std::vector<uint8_t> transposed(block_w * block_h);

    for (int y = 0; y < block_h; y++) {
        for (int x = 0; x < block_w; x++) {
            transposed[x * block_h + y] = block[y * block_w + x];
        }
    }

    return transposed;
}

std::vector<uint8_t> adaptive_scan(const uint8_t *image, int width, int height, int block_size) {
    std::vector<uint8_t> result;

    int blocks_x = (width + block_size - 1) / block_size;
    int blocks_y = (height + block_size - 1) / block_size;

    // store metadata about blocks in order to un-transpose on decompression
    result.push_back(blocks_x & 0xFF);
    result.push_back(blocks_y & 0xFF);

    std::vector<uint8_t> block_metadata;    // store scan type for each block
    std::vector<uint8_t> block_data;        // store actual block data
    
    // process each block
    for (int by = 0; by < blocks_y; by++) {
        for (int bx = 0; bx < blocks_x; bx++) {
            // extract block
            auto block = extract_block(image, width, height, bx, by, block_size);

            int block_w = std::min(block_size, width - bx * block_size);
            int block_h = std::min(block_size, height - by * block_size);

            // try horizontal scan (no transpose needed)
            double h_entropy = calculate_entropy(block);

            // try vertical scan (transpose)
            auto v_block = transpose_block(block, block_w, block_h);
            double v_entropy = calculate_entropy(v_block);

            // choose best scan direction
            uint8_t scan_type = (h_entropy <= v_entropy) ? 0 : 1;
            block_metadata.push_back(scan_type);

            auto &selected_block = (scan_type == 0) ? block : v_block;

            // append block data
            block_data.insert(block_data.end(), selected_block.begin(), selected_block.end());
        }
    }

    // append metadata then data
    result.insert(result.end(), block_metadata.begin(), block_metadata.end());
    result.insert(result.end(), block_data.begin(), block_data.end());

    return result;
}

std::vector<uint8_t> reverse_adaptive_scan(const std::vector<uint8_t> &data, int width, int height, int block_size) {
    if (data.size() < 2) {
        return {};
    }

    size_t offset = 0;
    int blocks_x = data[offset++];
    int blocks_y = data[offset++];

    // read block metadata
    std::vector<uint8_t> block_metadata;
    int num_blocks = blocks_x * blocks_y;
    if (offset + num_blocks > data.size()) {
        return {};  // invalid data
    }

    block_metadata.insert(block_metadata.end(), data.begin() + offset, data.begin() + offset + num_blocks);
    offset += num_blocks;

    // read block data
    std::vector<uint8_t> block_data(data.begin() + offset, data.end());

    // reconstruct image
    std::vector<uint8_t> result(width * height);

    size_t block_data_pos = 0;
    for (int by = 0; by < blocks_y; by++) {
        for (int bx = 0; bx < blocks_x; bx++) {
            int block_idx = by * blocks_x + bx;
            uint8_t scan_type = block_metadata[block_idx];

            int block_w = std::min(block_size, width - bx * block_size);
            int block_h = std::min(block_size, height - by * block_size);
            int block_bytes = block_w * block_h;

            if (block_data_pos + block_bytes > block_data.size()) {
                return {};  // invalid data
            }

            // extract block data
            std::vector<uint8_t> block(block_data.begin() + block_data_pos, block_data.begin() + block_data_pos + block_bytes);
            block_data_pos += block_bytes;

            // un-transpose if needed
            if (scan_type == 1) {
                block = transpose_block(block, block_h, block_w);
            }

            // write block back to image
            for (int y = 0; y < block_h; y++) {
                int dst_y = by * block_size + y;
                int dst_x_start = bx * block_size;
                std::memcpy(result.data() + dst_y * width + dst_x_start, block.data() + y * block_w, block_w);
            }
        }
    }

    return result;
}

// -------------------------------------
// --- MODEL MODULE - DELTA ENCODING ---
// -------------------------------------

std::vector<uint8_t> apply_delta_model(const std::vector<uint8_t> &data) {
    if (data.empty()) {
        return {};
    }

    std::vector<uint8_t> result;
    result.reserve(data.size());

    // store first pixel as-is
    result.push_back(data[0]);

    // store differences for subsequent pixels
    for (size_t i = 1; i < data.size(); i++) {
        // calculate delta as difference (with wrapping for unsigned overflow)
        uint8_t delta = data[i] - data[i - 1];
        result.push_back(delta);
    }

    return result;
}

std::vector<uint8_t> reverse_delta_model(const std::vector<uint8_t> &delta_data) {
    if (delta_data.empty()) {
        return {};
    }

    std::vector<uint8_t> result;
    result.reserve(delta_data.size());

    // reconstruct first pixel
    result.push_back(delta_data[0]);

    // reconstruct subsequent pixels
    for (size_t i = 1; i < delta_data.size(); i++) {
        // add delta to previous value (with wrapping)
        uint8_t reconstructed = result[i - 1] + delta_data[i];
        result.push_back(reconstructed);
    }

    return result;
}

// ---------------------------------
// --- COMPRESSION MODULE - LZ77 ---
// ---------------------------------

std::vector<uint8_t> lz77_compress(const std::vector<uint8_t> &data) {
    std::vector<uint8_t> output;
    output.reserve(data.size() * 2);    // initial guess

    size_t pos = 0;

    while (pos < data.size()) {
        // find the longest match in history window
        size_t best_offset = 0;
        size_t best_length = 0;

        // window extends backwards from current position
        size_t window_start = (pos > LZ77_WINDOW_SIZE) ? pos - LZ77_WINDOW_SIZE : 0;

        // search for matches in the window
        for (size_t window_pos = window_start; window_pos < pos; window_pos++) {
            // check how many bytes match
            size_t match_len = 0;
            while (match_len < LZ77_MAX_MATCH && window_pos + match_len < pos && pos + match_len < data.size() && data[window_pos + match_len] == data[pos + match_len]) {
                match_len++;
            }

            // update the best match if this one is better
            if (match_len >= LZ77_MIN_MATCH && match_len > best_length) {
                best_offset = pos - window_pos;
                best_length = match_len;
            }
        }

        // emit token
        if (best_length >= LZ77_MIN_MATCH) {
            // cap length at 255 since encoding as uint8_t
            uint8_t encoded_length = (best_length > 255) ? 255 : best_length;

            // emit match token
            output.push_back(0x01);
            output.push_back((best_offset >> 8) & 0xFF);
            output.push_back(best_offset & 0xFF);
            output.push_back(encoded_length);

            // only advance by the encoded length
            pos += encoded_length;
        } else {
            // emit literal token
            output.push_back(0x00);
            output.push_back(data[pos]);
            pos++;
        }
    }

    return output;
}

std::vector<uint8_t> lz77_decompress(const std::vector<uint8_t> &compressed) {
    std::vector<uint8_t> output;
    output.reserve(compressed.size() * 2);

    size_t pos = 0;

    while (pos < compressed.size()) {
        uint8_t token_type = compressed[pos];

        if (token_type == 0x00) {
            // literal token
            if (pos + 1 < compressed.size()) {
                output.push_back(compressed[pos + 1]);
                pos += 2;
            } else {
                pos++;  // malformed token
            }
        } else if (token_type == 0x01) {
            // match token
            if (pos + 3 < compressed.size()) {
                uint16_t offset = ((uint16_t) compressed[pos + 1] << 8) | compressed[pos + 2];
                uint8_t length = compressed[pos + 3];

                // validate offset
                if (offset > output.size() || offset == 0) {
                    pos += 4;
                    continue;   // skip invalid token
                }

                // copy from history
                size_t copy_pos = output.size() - offset;
                for (int i = 0; i < length; i++) {
                    output.push_back(output[copy_pos + i]);
                }

                pos += 4;
            } else {
                pos++;  // malformed token
            }
        } else {
            // skip invalid token
            pos++;
        }
    }

    return output;
}

// ---------------------------------------------
// --- ANALYSIS MODULE - ENTROPY AND METRICS ---
// ---------------------------------------------

std::vector<int> calculate_frequencies(const std::vector<uint8_t> &data) {
    std::vector<int> freq(256, 0);
    for (auto byte : data) {
        freq[byte]++;
    }

    return freq;
}

double calculate_entropy(const std::vector<uint8_t> &data) {
    if (data.empty()) {
        return 0.0;
    }

    auto freq = calculate_frequencies(data);

    double entropy = 0.0;
    double total = data.size();

    for (int i = 0; i < 256; i++) {
        if (freq[i] > 0) {
            double p = freq[i] / total;
            entropy -= p * std::log2(p);
        }
    }

    return entropy;
}

// ----------------
// --- FILE I/O ---
// ----------------

std::vector<uint8_t> read_file(const std::string &path) {
    std::ifstream file(path, std::ios::binary);
    if (!file) {
        return {};
    }

    // get file size
    file.seekg(0, std::ios::end);
    size_t size = file.tellg();
    file.seekg(0, std::ios::beg);

    // read entire file
    std::vector<uint8_t> data(size);
    file.read(reinterpret_cast<char*>(data.data()), size);

    return data;
}

bool write_file(const std::string &path, const std::vector<uint8_t> &data) {
    std::ofstream file(path, std::ios::binary);
    if (!file) {
        return false;
    }

    file.write(reinterpret_cast<const char*>(data.data()), data.size());
    return file.good();
}

// -------------------------
// --- UTILITY FUNCTIONS ---
// -------------------------

std::string format_size(size_t bytes) {
    const char *units[] = {"B", "KB", "MB", "GB"};
    double size = bytes;
    int unit = 0;

    while (size >= 1024.0 && unit < 3) {
        size /= 1024.0;
        unit++;
    }

    std::ostringstream oss;
    oss << std::fixed << std::setprecision(2) << size << " " << units[unit];

    return oss.str();
}

double calculate_ratio(size_t original, size_t compressed) {
    if (original == 0) {
        return 0.0;
    }

    return (double) compressed / original * 100.0;
}

double calculate_bits_per_pixel(size_t compressed_bytes, int num_pixels) {
    if (num_pixels == 0) {
        return 0.0;
    }

    return (double) compressed_bytes * 8.0 / num_pixels;
}
