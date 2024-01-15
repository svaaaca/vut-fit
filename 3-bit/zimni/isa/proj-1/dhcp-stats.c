/**
 * @file dhcp-stats.c
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of monitoring DHCP communication.
 * @date 2023-11-20
 */

#include "dhcp-stats.h"

int ip_prefix_count;                        // Number of IP prefixes.
struct dhcp_stats *dhcp_statistics = NULL;  // Structure for DHCP statistics.   
char **prefix_array = NULL;                 // Array for IP prefixes.
size_t prefix_array_size = 0;               // Size of DHCP addresses array.
int log_position = 0;                       // Position for log message.
char **log_array = NULL;                    // Array for log messages.
int log_index = 0;                          // Index for log messages array.

void usage(char *program_name) {
    printf("dhcp-stats: Monitoring DHCP communication.\n");
    printf("usage: %s [-h] [-r <filename>] [-i <interface-name>] <ip-prefix> [ <ip-prefix> [ ... ] ]\n", program_name);
    printf("options:\n");
    printf("  -h:         Display a usage message on standard output and exit.\n");
    printf("  -r:         Statistics will be created from pcap file.\n");
    printf("  -i:         An interface on which the program can listen.\n");
    printf("arguments:\n");
    printf("  ip-prefix:  Network range for which statistics will be generated.\n");
}

bool cidr_validate(char *ip_prefix) {
    char *prefix = strtok(ip_prefix, "/");
    char *mask = strtok(NULL, "/");
    if(prefix == NULL || mask == NULL) {
		fprintf(stderr, "dhcp-stats: Invalid ip-prefix '%s', use '-h' option to see usage.\n", ip_prefix);
		return false;
	}
	struct in_addr address;
	if(inet_pton(AF_INET, prefix, &address) <= PREFIX) {
		fprintf(stderr, "dhcp-stats: Invalid prefix '%s', use '-h' option to see usage.\n", prefix);
		return false;
	}
	if(atoi(mask) < MASK_MIN || atoi(mask) > MASK_MAX) {
		fprintf(stderr, "dhcp-stats: Invalid mask '%d', use '-h' option to see usage.\n", atoi(mask));
		return false;
	}
	return true;
}

bool within_range(struct in_addr address, char *ip_prefix) {
    char ip_address[INET_ADDRSTRLEN];
    int mask;
    if(sscanf(ip_prefix, "%15[^/]/%d", ip_address, &mask) != SSCANF_RETURN) {
        cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
    }
    struct in_addr ip_network_address;
    if(inet_pton(AF_INET, ip_address, &ip_network_address) <= PREFIX) {
        cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
    }
    uint32_t ip_network = ntohl(ip_network_address.s_addr) & (NETWORK_MASK << (MASK_MAX - mask));
    uint32_t ip_broadcast = ip_network | (NETWORK_MASK >> mask);
    uint32_t ip_address_check = ntohl(address.s_addr);
    const char network[] = "0.0.0.0";
    const char broadcast[] = "255.255.255.255";
    u_int32_t network_check = inet_addr(network);
    u_int32_t broadcast_check = inet_addr(broadcast);
    if(mask == MASK_MIN) {
        if((ip_address_check == network_check) || (ip_address_check == broadcast_check)) {
            return false;
        }
        return true;
    }
    else if(mask == MASK_MAX) {
        return false;
    }
    if((ip_address_check > ip_network) && (ip_address_check < ip_broadcast)) {
        return true;
    }
    else {
        return false;
    }
}

void packet_handler(u_char *user, const struct pcap_pkthdr *header, const u_char *packet) {
    (void) user;
    (void) header;
    bool flag = false;
    int percentage = 0;
    struct ether_header *ethernet_header = (struct ether_header *) packet;
    if(ntohs(ethernet_header->ether_type) != ETHERTYPE_IP) {
        return;
    }
    struct ip *ip_header = (struct ip *) (packet + sizeof(struct ether_header));
    if(ip_header->ip_p != IPPROTO_UDP) {
        return;
    }
    struct udp_hdr *udp_header = (struct udp_hdr *) (packet + sizeof(struct ether_header) + sizeof(struct ip));
    if(ntohs(udp_header->uh_sport) != DHCP_SERVER_PORT && ntohs(udp_header->uh_dport) != DHCP_CLIENT_PORT) {
        return;
    }
    struct dhcp_hdr *dhcp_header = (struct dhcp_hdr *) (packet + sizeof(struct ether_header) + sizeof(struct ip) + sizeof(struct udp_hdr));
    if(dhcp_header->magic_cookie != htonl(DHCP_MAGIC_COOKIE)) {
        return;
    }
    if(dhcp_header->yiaddr.s_addr == DHCP_YIADDR) {
        return;
    }
    const u_char *dhcp_options = dhcp_header->options;
    while(*dhcp_options != DHCP_END) {
        if(*dhcp_options == DHCP_OPTIONS_TYPE) {
            if(*(dhcp_options + 2) != DHCP_TYPE_ACK) {
                return;
            }
        }
        dhcp_options += *(dhcp_options + 1) + 2;
    }
    if(find_address(inet_ntoa(dhcp_header->yiaddr))) {
        return;
    }
    else {
        add_address(inet_ntoa(dhcp_header->yiaddr));
    }
    for(int i = 0; i < ip_prefix_count; i++) {
        if(within_range(dhcp_header->yiaddr, dhcp_statistics[i].ip_prefix)) {
            if(dhcp_statistics[i].allocated_addresses < dhcp_statistics[i].max_hosts) {
                dhcp_statistics[i].allocated_addresses++;
            }
            double temporary_utilization = dhcp_statistics[i].utilization;
            dhcp_statistics[i].utilization = (double) dhcp_statistics[i].allocated_addresses / dhcp_statistics[i].max_hosts;
            if((temporary_utilization <= 0.5) && (dhcp_statistics[i].utilization > 0.5)) {
                percentage = 50;
                flag = true;
            }
            else if((temporary_utilization <= 0.75) && (dhcp_statistics[i].utilization > 0.75)) {
                percentage = 75;
                flag = true;
            }
            else if((temporary_utilization <= 0.9) && (dhcp_statistics[i].utilization > 0.9)) {
                percentage = 90;
                flag = true;
            }
            else if((temporary_utilization <= 0.95) && (dhcp_statistics[i].utilization > 0.95)) {
                percentage = 95;
                flag = true;
            }
            if(flag) {
                syslog(LOG_NOTICE, "prefix %s exceeded %d%% of allocations", dhcp_statistics[i].ip_prefix, percentage);
                mvprintw(log_position++, COLUMN, "prefix %s exceeded %d%% of allocations", dhcp_statistics[i].ip_prefix, percentage);
                char *buffer = (char *) malloc(strlen("prefix ") + strlen(dhcp_statistics[i].ip_prefix) + strlen(" exceeded ") + TWO_DIGITS + strlen("% of allocations") + 1);
                if(buffer == NULL) {
                    cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
                }
                sprintf(buffer, "prefix %s exceeded %d%% of allocations", dhcp_statistics[i].ip_prefix, percentage);
                add_log(buffer);
                free(buffer);
                flag = false;
            }
        }
    }
    mvprintw(ROW, COLUMN, "IP-Prefix Max-hosts Allocated addresses Utilization");
    for(int i = 0; i < ip_prefix_count; i++) {
        mvprintw(i + 1, COLUMN, "%s %u %u %.2f%%", dhcp_statistics[i].ip_prefix, dhcp_statistics[i].max_hosts, dhcp_statistics[i].allocated_addresses, dhcp_statistics[i].utilization * 100);
    }
    refresh();
}

void print_statistics(void) {
    printf("IP-Prefix Max-hosts Allocated addresses Utilization\n");
    for(int i = 0; i < ip_prefix_count; i++) {
        printf("%s %u %u %.2f%%\n", dhcp_statistics[i].ip_prefix, dhcp_statistics[i].max_hosts, dhcp_statistics[i].allocated_addresses, dhcp_statistics[i].utilization * 100);
    }
    for(int i = 0; i < log_index; i++) {
        printf("%s\n", log_array[i]);
    }
}

void add_address(const char *ip_address) {
    if(prefix_array_size == 0) {
        prefix_array = (char **) malloc(sizeof(char *));
        if(prefix_array == NULL) {
            cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
        }
    }
    else {
        char **temporary = (char **) realloc(prefix_array, (prefix_array_size + 1) * sizeof(char *));
        if(temporary == NULL) {
            cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
        }
        prefix_array = temporary;
    }
    prefix_array[prefix_array_size] = strdup(ip_address);
    if(prefix_array[prefix_array_size] == NULL) {
        cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
    }
    prefix_array_size++;
}

bool find_address(const char *ip_address) {
    for(size_t i = 0; i < prefix_array_size; i++) {
        if(strcmp(prefix_array[i], ip_address) == STRCMP_EQUAL) {
            return true;
        }
    }
    return false;
}

void add_log(const char *log_message) {
    if(log_index == 0) {
        log_array = (char **) malloc(sizeof(char *));
        if(log_array == NULL) {
            cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
        }
    }
    else {
        char **temporary = (char **) realloc(log_array, (log_index + 1) * sizeof(char *));
        if(temporary == NULL) {
            cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
        }
        log_array = temporary;
    }
    log_array[log_index] = strdup(log_message);
    if(log_array[log_index] == NULL) {
        cleanup(FAIL, "dhcp-stats: Internal error, use '-h' option to see usage.");
    }
    log_index++;
}

void signal_handler(int signal) {
    (void) signal;
    cleanup(SUCCESS, NULL);
}

void free_memory(void) {
    for(int i = 0; i < ip_prefix_count; i++) {
        free(dhcp_statistics[i].ip_prefix);
    }
    free(dhcp_statistics);
    for(size_t i = 0; i < prefix_array_size; i++) {
        free(prefix_array[i]);
    }
    free(prefix_array);
    for(int i = 0; i < log_index; i++) {
        free(log_array[i]);
    }
    free(log_array);
}

void cleanup(int exit_code, const char *message) {
    endwin();
    if(exit_code == SUCCESS) {
        print_statistics();
    }
    free_memory();
    closelog();
    if(exit_code == FAIL && message != NULL) {
        fprintf(stderr, "%s\n", message);
    }
    exit(exit_code);
}

int main(int argc, char *argv[]) {
    int option;
    char *filename = NULL;
    char *interface_name = NULL;
    while((option = getopt(argc, argv, ":hr:i:")) != GETOPT_FAIL) {
        switch(option) {
            case 'h':
                usage(argv[0]);
                return SUCCESS;
            case 'r':
                filename = optarg;
                break;
            case 'i':
                interface_name = optarg;
                break;
            case ':':
                if(optopt == 'r')
                    fprintf(stderr, "dhcp-stats: Option '-%c' needs a filename, use '-h' option to see usage.\n", optopt);
                else if(optopt == 'i')
                    fprintf(stderr, "dhcp-stats: Option '-%c' needs an interface, use '-h' option to see usage.\n", optopt);
                return FAIL;
            case '?':
                fprintf(stderr, "dhcp-stats: Unknown option '-%c', use '-h' option to see usage.\n", optopt);
                return FAIL;
        }
    }
    if(filename == NULL && interface_name == NULL) {
        fprintf(stderr, "dhcp-stats: Missing required option '-r' or '-i', use '-h' option to see usage.\n");
        return FAIL;
    }
    if(filename != NULL && interface_name != NULL) {
        fprintf(stderr, "dhcp-stats: Options '-r' and '-i' are mutually exclusive, use '-h' option to see usage.\n");
        return FAIL;
    }
    if(optind == argc) {
        fprintf(stderr, "dhcp-stats: Missing required argument ip-prefix, use '-h' option to see usage.\n");
        return FAIL;
    }
    ip_prefix_count = argc - optind;
    log_position = ip_prefix_count + 1;
    for(; optind < argc; optind++) {
		char *prefix = strdup(argv[optind]);
        if(!cidr_validate(prefix)) {
            free(prefix);
			return FAIL;
		}
        free(prefix);
    }
    dhcp_statistics = (struct dhcp_stats *) malloc(ip_prefix_count * sizeof(struct dhcp_stats));
    if(dhcp_statistics == NULL) {
        fprintf(stderr, "dhcp-stats: Internal error, use '-h' option to see usage.\n");
        return FAIL;
    }
    for(int i = 0; i < ip_prefix_count; i++) {
        dhcp_statistics[i].ip_prefix = strdup(argv[argc - ip_prefix_count + i]);
        char *position = strchr(argv[argc - ip_prefix_count + i], '/');
        dhcp_statistics[i].max_hosts = (atoi(position + 1) == MASK_MAX) ? (MASK_MIN) : (pow(2, MASK_MAX - atoi(position + 1)) - 2);
        dhcp_statistics[i].allocated_addresses = 0;
        dhcp_statistics[i].utilization = 0.0;
    }
    setlogmask(LOG_UPTO(LOG_NOTICE));
    openlog("dhcp-stats", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_LOCAL1);
    initscr();
    cbreak();
    noecho();
    nodelay(stdscr, TRUE);
    keypad(stdscr, TRUE);
    curs_set(CURSOR);
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    signal(SIGQUIT, signal_handler);
    signal(SIGTSTP, signal_handler);
    signal(SIGKILL, signal_handler);
    mvprintw(ROW, COLUMN, "IP-Prefix Max-hosts Allocated addresses Utilization");
    for(int i = 0; i < ip_prefix_count; i++) {
        mvprintw(i + 1, COLUMN, "%s %u %u %.2f%%", dhcp_statistics[i].ip_prefix, dhcp_statistics[i].max_hosts, dhcp_statistics[i].allocated_addresses, dhcp_statistics[i].utilization * 100);
    }
    refresh();
    char error_buffer[PCAP_ERRBUF_SIZE];
	pcap_t *handle;
    if(filename != NULL) {
        handle = pcap_open_offline(filename, error_buffer);
        if(handle == NULL) {
            cleanup(FAIL, error_buffer);
        }
    }
    else {
        handle = pcap_open_live(interface_name, BUFSIZ, true, PCAP_TIMEOUT, error_buffer);
        if(handle == NULL) {
            cleanup(FAIL, error_buffer);
        }
    }
    pcap_loop(handle, PCAP_LOOP, packet_handler, NULL);
    pcap_close(handle);
    cleanup(SUCCESS, NULL);
}
