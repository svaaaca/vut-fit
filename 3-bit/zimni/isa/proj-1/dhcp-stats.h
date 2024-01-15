/**
 * @file dhcp-stats.h
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Header file for monitoring DHCP communication.
 * @date 2023-11-20
 */

#ifndef __DHCP_STATS_H__
#define __DHCP_STATS_H__

#include <stdio.h>              // Standard input/output definitions.
#include <stdlib.h>             // Standard library definitions.
#include <stdbool.h>            // Boolean definitions.
#include <string.h>             // String function definitions.
#include <getopt.h>             // Getopt function and constants.
#include <math.h>               // Math function definitions.
#include <pcap.h>               // Packet capture library.
#include <arpa/inet.h>          // Definitions for internet operations.
#include <netinet/ip.h>         // Internet Protocol family.
#include <netinet/if_ether.h>   // Ethernet protocol family.
#include <syslog.h>             // Definitions for system error logging.
#include <ncurses.h>            // Definitions for screen handling and optimization.
#include <signal.h>             // Signal handling definitions.

#define SUCCESS 0                       // Macro for success return value.
#define FAIL 1                          // Macro for failure return value.
#define CHADDR 16                       // Macro for DHCP chaddr size.
#define SNAME 64                        // Macro for DHCP sname size.
#define FILE 128                        // Macro for DHCP file size.
#define OPTIONS 308                     // Macro for DHCP options size.
#define STATS_SIZE 10                   // Macro for DHCP statistics size.
#define GETOPT_FAIL -1                  // Macro for getopt failure.
#define PREFIX 0                        // Macro for IPv4 prefix.
#define MASK_MIN 0                      // Macro for IPv4 minimum mask.
#define MASK_MAX 32                     // Macro for IPv4 maximum mask.
#define NETWORK_MASK 0xFFFFFFFF         // Macro for IPv4 network mask.
#define PCAP_LOOP 0                     // Macro for pcap loop.
#define PCAP_TIMEOUT 1000               // Macro for pcap timeout.
#define DHCP_SERVER_PORT 67             // Macro for DHCP server port.
#define DHCP_CLIENT_PORT 68             // Macro for DHCP client port.
#define DHCP_MAGIC_COOKIE 0x63825363    // Macro for DHCP magic cookie.
#define DHCP_YIADDR 0                   // Macro for DHCP yiaddr value.
#define DHCP_END 255                    // Macro for DHCP end option.
#define DHCP_OPTIONS_TYPE 53            // Macro for DHCP options type.
#define DHCP_TYPE_ACK 5                 // Macro for DHCP ACK type.
#define CURSOR 0                        // Macro for cursor position.
#define ROW 0                           // Macro for row position.
#define COLUMN 0                        // Macro for column position.
#define STRCMP_EQUAL 0                  // Macro for strcmp equal.
#define SSCANF_RETURN 2                 // Macro for sscanf return value.
#define TWO_DIGITS 2                    // Macro for two digits.

/**
 * @brief Structure for UDP header.
 * 
 */
struct udp_hdr {
    u_int16_t uh_sport; // Source port.
    u_int16_t uh_dport; // Destination port.
    u_int16_t uh_ulen;  // Length.
    u_int16_t uh_sum;   // Checksum.
};

/**
 * @brief Structure for DHCP header.
 * 
 */
struct dhcp_hdr {
    u_int8_t op;                // Message op code / message type (1 = BOOTREQUEST, 2 = BOOTREPLY).
    u_int8_t htype;             // Hardware address type, see ARP section in "Assigned Numbers" RFC; e.g., '1' = 10mb ethernet.
    u_int8_t hlen;              // Hardware address length (e.g. '6' for 10mb ethernet).
    u_int8_t hops;              // Client sets to zero, optionally used by relay agents when booting via a relay agent.
    u_int32_t xid;              // Transaction ID, a random number chosen by the client, used by the client and server to associate messages and responses between a client and a server.
    u_int16_t secs;             // Filled in by client, seconds elapsed since client began address acquisition or renewal process.
    u_int16_t flags;            // Flags.
    struct in_addr ciaddr;      // Client IP address; only filled in if client is in BOUND, RENEW or REBINDING state and can respond to ARP requests.
    struct in_addr yiaddr;      // 'your' (client) IP address.
    struct in_addr siaddr;      // IP address of next server to use in bootstrap; returned in DHCPOFFER, DHCPACK by server.
    struct in_addr giaddr;      // Relay agent IP address, used in booting via a relay agent.
    u_int8_t chaddr[CHADDR];    // Client hardware address.
    char sname[SNAME];          // Optional server host name, null terminated string.
    char file[FILE];            // Boot file name, null terminated string; "generic" name or null in DHCPDISCOVER, fully qualified directory-path name in DHCPOFFER.
    u_int32_t magic_cookie;     // Fixed first four option bytes (99, 130, 83, 99 dec or 63, 82, 53, 63 hex).
    u_int8_t options[OPTIONS];  // Optional parameters field.
};

/**
 * @brief Structure for DHCP statistics.
 * 
 */
struct dhcp_stats {
    char *ip_prefix;                // Network prefix.
    u_int32_t max_hosts;            // Maximum number of hosts.
    u_int32_t allocated_addresses;  // Number of allocated addresses.
    double utilization;             // Utilization of the network.
};

/**
 * @brief Function for printing help message.
 * 
 * @param program_name Name of the program.
 */
void usage(char *program_name);

/**
 * @brief Function for validating network prefix in CIDR notation.
 * 
 * @param ip_prefix Network prefix to be validated.
 * @return True if the network prefix is valid, false otherwise.
 */
bool cidr_validate(char *ip_prefix);

/**
 * @brief Function for checking if the address is within the network prefix.
 * 
 * @param address IP address to be checked.
 * @param ip_prefix Network prefix.
 * @return True if the address is within the network prefix, false otherwise.
 */
bool within_range(struct in_addr address, char *ip_prefix);

/**
 * @brief Function for handling packets.
 * 
 * @param user User data.
 * @param header Header of the packet.
 * @param packet Packet data.
 */
void packet_handler(u_char *user, const struct pcap_pkthdr *header, const u_char *packet);

/**
 * @brief Function for printing statistics.
 * 
 */
void print_statistics(void);

/**
 * @brief Function for adding IP address to the list of IP addresses.
 * 
 * @param ip_address IP address to be added.
 */
void add_address(const char *ip_address);

/**
 * @brief Function for finding IP address in the list of IP addresses.
 * 
 * @param ip_address IP address to be found.
 * @return True if the IP address is found, false otherwise.
 */
bool find_address(const char *ip_address);

/**
 * @brief Function for adding log message to the list of log messages.
 * 
 * @param log_message Log message to be added.
 */
void add_log(const char *log_message);

/**
 * @brief Function for handling signals.
 * 
 * @param signal Signal to be handled.
 */
void signal_handler(int signal);

/**
 * @brief Function for freeing allocated memory.
 * 
 */
void free_memory(void);

/**
 * @brief Function for cleaning up and exiting the program.
 * 
 * @param exit_code Exit code.
 * @param message Message to be printed.
 */
void cleanup(int exit_code, const char *message);

#endif // __DHCP_STATS_H__
