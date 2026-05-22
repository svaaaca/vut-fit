/**
 * @file main.cpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Main entry point for image data compression and decompression program.
 * @date 2026-05-04
 */

#include "args.hpp"
#include "codec.hpp"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <ctime>

/**
 * @brief Calculate the height of the image based on the file size and width.
 * 
 * @param file_size Size of the input file in bytes.
 * @param width Width of the image in pixels.
 * @return Height of the image in pixels.
 */
int get_height(size_t file_size, int width) {
    if (width <= 0) {
        return -1;
    }

    if (file_size % width != 0) {
        return -1;
    }

    int height = file_size / width;

    return height;
}

/**
 * @brief Perform the compression process.
 * 
 * @param args Parsed command-line arguments containing input/output file paths and options.
 * @return True on success, false on failure.
 */
bool compression(const ParsedArgs &args) {
    // read input file
    auto image_data = read_file(args.infile);
    if (image_data.empty()) {
        std::cerr << "Nepodařilo se načíst vstupní soubor.\n";
        return false;
    }

    int height = get_height(image_data.size(), args.width);
    if (height <= 0) {
        std::cerr << "Neplatná velikost souboru pro zadanou šířku.\n";
        return false;
    }

    // scan image
    std::vector<uint8_t> scanned;

    if (args.adaptive_scan) {
        scanned = adaptive_scan(image_data.data(), args.width, height);
    } else {
        scanned = static_scan(image_data.data(), args.width, height);
    }

    // apply model
    std::vector<uint8_t> modeled = scanned;
    if (args.use_model) {
        modeled = apply_delta_model(scanned);
    }

    // compress with LZ77
    auto compressed = lz77_compress(modeled);

    // create header and finalize output
    CompressionHeader header;
    header.magic = FILE_MAGIC;
    header.width = args.width;
    header.height = height;
    header.flags = (args.use_model ? 0x01 : 0x00) | (args.adaptive_scan ? 0x02 : 0x00);
    header.block_size = ADAPTIVE_BLOCK_SIZE;

    auto header_bytes = header.serialize();

    // combine header and compressed data
    std::vector<uint8_t> output;
    output.insert(output.end(), header_bytes.begin(), header_bytes.end());
    output.insert(output.end(), compressed.begin(), compressed.end());

    // write output
    if (!write_file(args.outfile, output)) {
        std::cerr << "Nepodařilo se zapsat výstupní soubor.\n";
        return false;
    }

    return true;
}

/**
 * @brief Perform the decompression process.
 * 
 * @param args Parsed command-line arguments containing input/output file paths and options.
 * @return True on success, false on failure.
 */
bool decompression(const ParsedArgs &args) {
    // read compressed file
    auto compressed_file = read_file(args.infile);
    if (compressed_file.empty()) {
        std::cerr << "Nepodařilo se načíst vstupní soubor.\n";
        return false;
    }

    // parse header
    size_t offset = 0;
    if (compressed_file.size() < 11) {
        std::cerr << "Soubor je příliš malý, nemůže obsahovat platnou hlavičku.\n";
        return false;
    }

    CompressionHeader header;
    try {
        header = CompressionHeader::deserialize(compressed_file, offset);
    } catch (const std::exception &e) {
        std::cerr << "Nepodařilo se načíst hlavičku souboru: " << e.what() << "\n";
        return false;
    }

    if (header.magic != FILE_MAGIC) {
        std::cerr << "Neplatné magické číslo souboru.\n";
        return false;
    }

    bool use_model = (header.flags & 0x01) != 0;
    bool use_adaptive = (header.flags & 0x02) != 0;

    int total_pixels = header.width * header.height;

    // decompress with LZ77
    std::vector<uint8_t> compressed_data(compressed_file.begin() + offset, compressed_file.end());
    auto decompressed = lz77_decompress(compressed_data);

    // reverse model
    std::vector<uint8_t> modeled_reversed = decompressed;
    if (use_model) {
        modeled_reversed = reverse_delta_model(decompressed);
    }

    // reverse scan
    std::vector<uint8_t> output;
    if (use_adaptive) {
        output = reverse_adaptive_scan(modeled_reversed, header.width, header.height);
    } else {
        output = modeled_reversed;
    }

    // verify size
    if ((int) output.size() != total_pixels) {
        // this may happen with adaptive scanning due to metadata (truncate or pad as needed)
        if ((int) output.size() > total_pixels) {
            output.resize(total_pixels);
        } else {
            std::cerr << "Nesoulad ve velikosti výstupu:\n";
            std::cerr << "  - očekávaná: " << total_pixels << " bajtů,\n";
            std::cerr << "  - skutečná:  " << output.size() << " bajtů.\n";
            // try to pad with zeros if needed
            while ((int) output.size() < total_pixels) {
                output.push_back(0);
            }
        }
    }

    // write output
    if (!write_file(args.outfile, output)) {
        std::cerr << "Nepodařilo se zapsat výstupní soubor.\n";
        return false;
    }

    return true;
}

int main(int argc, char *argv[]) {
    ParsedArgs args = parse_arguments(argc, argv);

// #ifdef DEBUG
    std::cout << "Režim: " << (args.decompress ? "dekomprese" : "komprese") << "\n";
    std::cout << "Vstupní soubor: " << args.infile << "\n";
    std::cout << "Výstupní soubor: " << args.outfile << "\n";

    if (!args.decompress) {
        std::cout << "Šířka obrazu: " << args.width << "\n";
        std::cout << "Model: " << (args.use_model ? "aktivní" : "neaktivní") << "\n";
        std::cout << "Skenování: " << (args.adaptive_scan ? "adaptivní" : "sekvenční") << "\n";
    }
// #endif


	std::ifstream in(args.infile, std::ios::binary);
    if (!in) {
        std::cerr << "Nelze otevřít vstupní soubor: " << args.infile << "\n";
        return 1;
    }

    std::ofstream out(args.outfile, std::ios::binary);
    if (!out) {
        std::cerr << "Nelze otevřít výstupní soubor: " << args.outfile << "\n";
        return 1;
    }

    // Perform requested operation
    bool success = args.decompress ? decompression(args) : compression(args);
    
    if (!success) {
        return 1;
    }
    
    return 0;
}
