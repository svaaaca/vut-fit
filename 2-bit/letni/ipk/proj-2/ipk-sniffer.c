/**
 * @file ipk-sniffer.c
 * @author David Kvacek (xkvace00)
 * @brief Network analyzer capturing and filtering packets on a specific network interface.
 * @version 1.0
 * @date 2023-04-17
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <signal.h>
#include <ctype.h>
#include <time.h>

#include <pcap.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip6.h>
#include <netinet/ip_icmp.h>
#include <netinet/if_ether.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>

#define OK 0
#define FAIL 1
#define TIME_BUFFER 32
#define MAX_PORT 65535
#define TIMEOUT 1000

/**
 * @brief prints help message
 * @return int 0
 */
void help() {
    printf("Network analyzer capturing and filtering packets\non a specific network interface.\n");
    printf("\nUsage:\t./ipk-sniffer [-i interface | --interface interface]\n\t{-p port [-t | --tcp] [-u | --udp]} [--arp] [--icmp4]\n\t[--icmp6] [--igmp] [--mld] {-n num}\n");
    printf("\nwhere:");
    printf("\t-i interface (just one interface to sniff) or --interface interface;\n\tif this parameter is not specified,\n\ta list of active interfaces is printed.\n\n");
    printf("\t-t or --tcp (will display TCP segments\n\tand is optionally complemented by -p functionality).\n\n");
    printf("\t-u or --udp (will display UDP datagrams\n\tand is optionally complemented by-p functionality).\n\n");
    printf("\t-p port (extends previous two parameters\n\tto filter TCP/UDP based on port number;\n\tif this parameter is not present,\n\tthen no filtering by port number occurs;\n\tif the parameter is given, the given port can occur\n\tin both the source and destination part of TCP/UDP headers).\n\n");
    printf("\t--icmp4 (will display only ICMPv4 packets).\n\n");
    printf("\t--icmp6 (will display only ICMPv6 echo request/response).\n\n");
    printf("\t--arp (will display only ARP frames).\n\n");
    printf("\t--ndp (will display only ICMPv6 NDP packets).\n\n");
    printf("\t--igmp (will display only IGMP packets).\n\n");
    printf("\t--mld (will display only MLD packets).\n\n");
    printf("\t-n 10 (specifies the number of packets to display,\n\ti.e., the 'time' the program runs;\n\tif not specified, only one packet,\n\ti.e., as if -n 1, will be displayed).\n");
    exit(OK);
}

/**
 * @brief prints list of active interfaces
 * @return int 0 if success, 1 if fail
 */
void active_interface_list() {
    char error_buffer[PCAP_ERRBUF_SIZE];
    pcap_if_t *all_interfaces, *active_interfaces;
    if(pcap_findalldevs(&all_interfaces, error_buffer) == -1) {
        fprintf(stderr, "ipk-sniffer: pcap_findalldevs: %s\n", error_buffer);
        exit(FAIL);
    }
    else {
        active_interfaces = all_interfaces;
        while(active_interfaces != NULL) {
            printf("%s\n", active_interfaces->name);
            active_interfaces = active_interfaces->next;
        }
    }
    exit(OK);
}

/**
 * @brief prints timestamp in RFC 3339 format with milliseconds and zone offset
 * @return void
 */
void timestamp() {
    char time_buffer[TIME_BUFFER];
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    struct tm *time_info = localtime(&time.tv_sec);
    strftime(time_buffer, TIME_BUFFER, "%FT%T", time_info);
    printf("timestamp:\t%s.%03ld%+03ld:%02ld\n", time_buffer, time.tv_nsec / 1000000, time_info->tm_gmtoff / 3600, time_info->tm_gmtoff % 3600);
}

/**
 * @brief prints packet information
 * @param args user arguments
 * @param header packet header
 * @param packet processed packet
 * @return void
 */
void packet_handler(u_char *args, const struct pcap_pkthdr *header, const u_char *packet) {
    struct ether_header *ethernet_header = (struct ether_header *) packet;
    char *source_mac = ether_ntoa((struct ether_addr *) &ethernet_header->ether_shost);
    char *destination_mac = ether_ntoa((struct ether_addr *) &ethernet_header->ether_dhost);

    struct ip *ip_header = (struct ip *) (packet + sizeof(struct ether_header));
    char source_ip[INET6_ADDRSTRLEN], destination_ip[INET6_ADDRSTRLEN];
    if(ip_header->ip_v == 4) {
        inet_ntop(AF_INET, &(ip_header->ip_src), source_ip, INET_ADDRSTRLEN);
        inet_ntop(AF_INET, &(ip_header->ip_dst), destination_ip, INET_ADDRSTRLEN);
    }
    else if(ip_header->ip_v == 6) {
        inet_ntop(AF_INET6, &(ip_header->ip_src), source_ip, INET6_ADDRSTRLEN);
        inet_ntop(AF_INET6, &(ip_header->ip_dst), destination_ip, INET6_ADDRSTRLEN);
    }

    u_int8_t *payload = (u_int8_t *) (packet + sizeof(struct ether_header) + ip_header->ip_hl * 4);
    u_int16_t payload_len = header->len - sizeof(struct ether_header) - ip_header->ip_hl * 4;
    char source_port_string[6], destination_port_string[6];
    int source_port = -1, destination_port = -1;
    if(ip_header->ip_p == IPPROTO_TCP) {
        struct tcphdr *tcp_header = (struct tcphdr *) payload;
        source_port = ntohs(tcp_header->th_sport);
        destination_port = ntohs(tcp_header->th_dport);
    }
    else if(ip_header->ip_p == IPPROTO_UDP) {
        struct udphdr *udp_header = (struct udphdr *) payload;
        source_port = ntohs(udp_header->uh_sport);
        destination_port = ntohs(udp_header->uh_dport);
    }

    if(source_port != -1)
        snprintf(source_port_string, sizeof(source_port_string), "%d", source_port);
    else
        strcpy(source_port_string, "-");

    if(destination_port != -1)
        snprintf(destination_port_string, sizeof(destination_port_string), "%d", destination_port);
    else
        strcpy(destination_port_string, "-");

    timestamp();
    printf("src MAC:\t%02x:%02x:%02x:%02x:%02x:%02x\n", ethernet_header->ether_shost[0], ethernet_header->ether_shost[1], ethernet_header->ether_shost[2], ethernet_header->ether_shost[3], ethernet_header->ether_shost[4], ethernet_header->ether_shost[5]);
    printf("dst MAC:\t%02x:%02x:%02x:%02x:%02x:%02x\n", ethernet_header->ether_dhost[0], ethernet_header->ether_dhost[1], ethernet_header->ether_dhost[2], ethernet_header->ether_dhost[3], ethernet_header->ether_dhost[4], ethernet_header->ether_dhost[5]);
    printf("frame length:\t%u bytes\n", header->len);
    printf("src IP:\t\t%s\n", source_ip);
    printf("dst IP:\t\t%s\n", destination_ip);
    printf("src port:\t%s\n", source_port_string);
    printf("dst port:\t%s\n", destination_port_string);

    for(int i = 0; i < payload_len; i++) {
        if(i % 16 == 0) {
            printf("\n%04x:\t", i);
        }
        printf("%02x ", payload[i]);
        if(i % 16 == 15) {
            for(int j = i - 15; j <= i; j++) {
                if(j == i - 7)
                    printf(" ");
                if(isprint(payload[j])) {
                    printf("%c", payload[j]);
                }
                else {
                    printf(".");
                }
            }
        }
    }
    printf("\n");
}

/**
 * @brief main function of ipk-sniffer
 * @param argc number of arguments
 * @param argv array of arguments
 * @return int 0 if program ends successfully, 1 otherwise
 */
int main(int argc, char *argv[]) {
    bool is_interface = false;
    char *interface = "any";
    bool is_port = false;
    int port = -1;
    bool tcp = false;
    bool udp = false;
    bool arp = false;
    bool icmp4 = false;
    bool icmp6 = false;
    bool igmp = false;
    bool mld = false;
    bool is_num = false;
    int num = 1;

    int i = 1;
    while(i < argc) {
        if(strcmp(argv[i], "-i") == 0 || strcmp(argv[i], "--interface") == 0) {
            is_interface = true;
            if(i + 1 < argc) {
                interface = argv[i + 1];
                i += 2;
            }
            else {
                active_interface_list();
            }
        }
        else if(strcmp(argv[i], "-p") == 0) {
            is_port = true;
            if(i + 1 >= argc) {
                fprintf(stderr, "ipk-sniffer: missing port number\n");
                exit(FAIL);
            }
            port = atoi(argv[i + 1]);
            i += 2;
        }
        else if(strcmp(argv[i], "--tcp") == 0 || strcmp(argv[i], "-t") == 0) {
            tcp = true;
            i++;
        }
        else if(strcmp(argv[i], "--udp") == 0 || strcmp(argv[i], "-u") == 0) {
            udp = true;
            i++;
        }
        else if(strcmp(argv[i], "--arp") == 0) {
            arp = true;
            i++;
        }
        else if(strcmp(argv[i], "--icmp4") == 0) {
            icmp4 = true;
            i++;
        }
        else if(strcmp(argv[i], "--icmp6") == 0) {
            icmp6 = true;
            i++;
        }
        else if(strcmp(argv[i], "--igmp") == 0) {
            igmp = true;
            i++;
        }
        else if(strcmp(argv[i], "--mld") == 0) {
            mld = true;
            i++;
        }
        else if(strcmp(argv[i], "-n") == 0) {
            is_num = true;
            if (i + 1 < argc) {
                num = atoi(argv[i + 1]);
                i += 2;
            }
        }
        else if(strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            help();
        }
        else {
            fprintf(stderr, "ipk-sniffer: invalid option\n");
            exit(FAIL);
        }
    }

    if(is_port && (port < 0 || port > MAX_PORT)) {
        fprintf(stderr, "ipk-sniffer: invalid port number\n");
        exit(FAIL);
    }

    if(tcp && udp) {
        fprintf(stderr, "ipk-sniffer: cannot use both tcp and udp\n");
        exit(FAIL);
    }

    if(num < 1) {
        fprintf(stderr, "ipk-sniffer: invalid number of packets\n");
        exit(FAIL);
    }

    if(!is_interface && !is_port && !tcp && !udp && !arp && !icmp4 && !icmp6 && !igmp && !mld) {
        active_interface_list();
    }

    pcap_t *session_handle;
	char error_buffer[PCAP_ERRBUF_SIZE];
	struct bpf_program compiled_filter;
	bpf_u_int32 net, mask;
	struct pcap_pkthdr header;
	const u_char *packet;
    char filter_expression[BUFSIZ] = "";

    if(is_port) {
        if(tcp)
            sprintf(filter_expression, "tcp port %d", port);
        else if(udp)
            sprintf(filter_expression, "udp port %d", port);
        else
            sprintf(filter_expression, "port %d", port);
    }

    if(arp)
        strcat(filter_expression, " arp");
    if(icmp4)
        strcat(filter_expression, " icmp");
    if(icmp6)
        strcat(filter_expression, " icmp6");
    if(igmp)
        strcat(filter_expression, " igmp");
    if(mld)
        strcat(filter_expression, " mld");

    strcat(filter_expression, "\0");

	if(pcap_lookupnet(interface, &net, &mask, error_buffer) == -1) {
		fprintf(stderr, "ipk-sniffer: could not get netmask for interface %s", interface);
		net = 0;
		mask = 0;
	}

	session_handle = pcap_open_live(interface, BUFSIZ, 1, TIMEOUT, error_buffer);
	if(session_handle == NULL) {
		fprintf(stderr, "ipk-sniffer: pcap_open_live: %s\n", error_buffer);
		exit(FAIL);
	}

	if(pcap_compile(session_handle, &compiled_filter, filter_expression, 0, PCAP_NETMASK_UNKNOWN) == -1) {
		fprintf(stderr, "ipk-sniffer: pcap_compile: %s\n", pcap_geterr(session_handle));
		exit(FAIL);
	}

	if(pcap_setfilter(session_handle, &compiled_filter) == -1) {
		fprintf(stderr, "ipk-sniffer: pcap_setfilter: %s\n", pcap_geterr(session_handle));
		exit(FAIL);
	}
	
    pcap_loop(session_handle, num, packet_handler, (u_char *) interface);
    pcap_freecode(&compiled_filter);
	pcap_close(session_handle);

    exit(OK);
}
