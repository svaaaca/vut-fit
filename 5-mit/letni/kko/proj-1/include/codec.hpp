/**
 * @file codec.hpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Header file for image data compression and decompression functions.
 * @date 2026-05-03
 */

#pragma once

#include <vector>
#include <cstdint>
#include <string>
#include <cmath>
#include <stdexcept>

// -----------------
// --- CONSTANTS ---
// -----------------
 
constexpr int LZ77_WINDOW_SIZE = 32768;     // 32 KB history window
constexpr int LZ77_MIN_MATCH = 3;           // minimum match length
constexpr int LZ77_MAX_MATCH = 258;         // maximum match length
 
constexpr uint32_t FILE_MAGIC = 0x4C5A4331; // "LZC1" in hex
constexpr int ADAPTIVE_BLOCK_SIZE = 16;     // 16x16 pixels

// ------------------
// --- STRUCTURES ---
// ------------------
 
/**
 * @struct CompressionHeader
 * @brief Header for compressed files, contains metadata needed for decompression.
 */
struct CompressionHeader {
    uint32_t magic;         // file magic number
    uint16_t width;         // image width
    uint16_t height;        // image height
    uint8_t flags;          // model (0), adaptive (1) bit
    uint16_t block_size;    // block size for adaptive scanning (if used)

    // serialize header to byte vector
    std::vector<uint8_t> serialize() const;

    // deserialize header from byte vector
    static CompressionHeader deserialize(const std::vector<uint8_t> &data, size_t &offset);
};

/**
 * @struct BlockResult
 * @brief Result of scanning a single block.
 */
struct BlockResult {
    std::vector<uint8_t> data;  // block data after scanning
    uint8_t scan_type;          // horizontal (0), vertical (1) scan
    bool is_compressed;         // whether compression was applied
    double entropy;             // entropy of this block
};

// ----------------------
// --- SCANNER MODULE ---
// ----------------------

/**
 * @brief Scan image using simple left-to-right, top-to-bottom order.
 * 
 * @param image Pointer to image data (width * height bytes).
 * @param width Image width in pixels.
 * @param height Image height in pixels.
 * @return Serialized 1D data stream.
 */
std::vector<uint8_t> static_scan(const uint8_t *image, int width, int height);

/**
 * @brief Adaptively scan image using blocks, chooses best scan direction per block.
 * 
 * @param image Pointer to image data.
 * @param width Image width.
 * @param height Image height.
 * @param block_size Size of blocks (e.g., 16 for 16x16).
 * @return Serialized data with scan metadata.
 */
std::vector<uint8_t> adaptive_scan(const uint8_t *image, int width, int height, int block_size = ADAPTIVE_BLOCK_SIZE);

/**
 * @brief Reverse adaptive scan back to 2D image format, handles un-transposing of blocks that were scanned vertically.
 * 
 * @param data Adaptive-scanned data with metadata.
 * @param width Image width.
 * @param height Image height.
 * @param block_size Size of blocks.
 * @return Original image data (2D flattened).
 */
std::vector<uint8_t> reverse_adaptive_scan(const std::vector<uint8_t> &data, int width, int height, int block_size = ADAPTIVE_BLOCK_SIZE);

// ------------------------------------------
// --- MODEL MODULE (Data Transformation) ---
// ------------------------------------------

/**
 * @brief Apply delta encoding to reduce data variance, encodes differences between consecutive pixels, first pixel stored as-is, subsequent pixels store delta.
 * 
 * @param data Input pixel data.
 * @return Delta-encoded data.
 */
std::vector<uint8_t> apply_delta_model(const std::vector<uint8_t> &data);

/**
 * @brief Reverse delta encoding, reconstructs original pixel values from deltas.
 * 
 * @param delta_data Delta-encoded data.
 * @return Original pixel data.
 */
std::vector<uint8_t> reverse_delta_model(const std::vector<uint8_t> &delta_data);

// ---------------------------------
// --- COMPRESSION MODULE (LZ77) ---
// ---------------------------------

/**
 * @brief Compress data using LZ77 algorithm, uses sliding window and pattern matching.
 * 
 * @param data Uncompressed data.
 * @return Compressed data with tokens.
 */
std::vector<uint8_t> lz77_compress(const std::vector<uint8_t> &data);
 
/**
 * @brief Decompress data compressed by lz77_compress.
 * 
 * @param compressed Compressed data.
 * @return Decompressed data.
 */
std::vector<uint8_t> lz77_decompress(const std::vector<uint8_t> &compressed);

// -------------------------------------------------------
// --- ANALYSIS MODULE (Entropy & Compression Metrics) ---
// -------------------------------------------------------

/**
 * @brief Calculate Shannon entropy of data, representing theoretical minimum bits per byte.
 * 
 * @param data Input data.
 * @return Entropy in bits per symbol.
 */
double calculate_entropy(const std::vector<uint8_t> &data);

/**
 * @brief Calculate frequency distribution of byte values.
 * 
 * @param data Input data.
 * @return Array of 256 frequency counts.
 */
std::vector<int> calculate_frequencies(const std::vector<uint8_t> &data);

// ----------------
// --- FILE I/O ---
// ----------------

/**
 * @brief Read entire file into memory as byte vector.
 * 
 * @param path File path.
 * @return File contents, or empty vector if error.
 */
std::vector<uint8_t> read_file(const std::string &path);

/**
 * @brief Write byte vector to file.
 * 
 * @param path Output file path.
 * @param data Data to write.
 * @return True if successful.
 */
bool write_file(const std::string &path, const std::vector<uint8_t> &data);

// ---------------
// --- UTILITY ---
// ---------------

/**
 * @brief Format file size nicely for display.
 * 
 * @param bytes Number of bytes.
 * @return Formatted string (e.g., "1.23 MB").
 */
std::string format_size(size_t bytes);

/**
 * @brief Calculate compression ratio.
 * 
 * @param original Original size in bytes.
 * @param compressed Compressed size in bytes.
 * @return Compression ratio as percentage (0-100).
 */
double calculate_ratio(size_t original, size_t compressed);

/**
 * @brief Calculate bits per pixel.
 * 
 * @param compressed_bits Total compressed bits.
 * @param num_pixels Number of pixels.
 * @return Bits per pixel.
 */
double calculate_bits_per_pixel(size_t compressed_bytes, int num_pixels);
