<!--
/**
  * @file readme.md
  * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
  * @brief Readme file for the implementation of the dhcp-stats utility.
  * @date 2023-11-20
  */
-->

# Monitorování DHCP komunikace

**Autor**: David Kvaček (xkvace00@stud.fit.vutbr.cz)\
**Datum**: 20.11.2023

## Popis programu

Program **dhcp-stats** je uživatelská utilita umožňující získat statistiku o vytížení síťového prefixu z pohledu množství alokovaných IP adres.
Při zaplnění prefixu z více jak 50%, 75%, 90% a 95%, nástroj informuje administrátora na standardní výstup a zalogováním skrz `syslog` server.
Program po spuštění začne monitorovat DHCP provoz na zvoleném rozhraní, případně zpracuje *pcap* soubor, a generovat si statistiku vytížení síťového prefixu, který mu byl zadán v příkazové řádce.
Prefixů může být více a mohou se překrývat – důvodem možného překryvu je zjištění, jak by vypadalo vytížení sítě, kdyby byl prefix větší.

### Omezení

* Nástroj **dhcp-stats** nepodporuje adresy IPv6 a komunikaci DHCPv6.
* Zprávy `DHCPRELEASE`, `DHCPDECLINE` a aktualizace síťových prefixů na základě vypršení *lease-time* nejsou podporovány.
* Utilita **dhcp-stats** také předpokládá DHCP komunikaci na standardních portech 67 a 68.

## Shrnutí
### Použití
```bash
$ ./dhcp-stats [-h] [-r <filename>] [-i <interface-name>] <ip-prefix> [ <ip-prefix> [ ... ] ]
```

`-h` – zobrazení nápovědy k použití na standardní výstup a ukončení.\
`-r <filename>` – statistika bude vytvořena z *pcap* souboru.\
`-i <interface-name>` – rozhraní, na kterém může program naslouchat.\
`<ip-prefix>` – rozsah sítě, pro které se bude generovat statistika.

### Status ukončení
Program **dhcp-stats** skončí s návratovou hodnotou 0 v případě úspěchu a s návratovou hodnotou >0 v případě chyby.
### Příklad spuštění
Zpracování DHCP komunikace z *pcap* souboru `homenetwork.pcap` pro síťové prefixy `192.168.1.0/24`, `192.168.0.0/22` a `172.16.32.0/24`:
```bash
$ ./dhcp-stats -r homenetwork.pcap 192.168.1.0/24 192.168.0.0/22 172.16.32.0/24
```
Monitorování DHCP komunikace na rozhraní `eth0` pro síťové prefixy `192.168.1.0/24`, `192.168.0.0/22` a `172.16.32.0/24`:
```bash
$ ./dhcp-stats -i eth0 192.168.1.0/24 192.168.0.0/22 172.16.32.0/24
```
### Výstup
```bash
$ ./dhcp-stats -i eth0 192.168.1.0/24 192.168.0.0/22 172.16.32.0/24
IP-Prefix Max-hosts Allocated addresses Utilization
192.168.0.0/22 1022 123 12.04%
192.168.1.0/24 254 123 48.43%
172.16.32.0/24 254 15 5.9%
```
### Logování
V případě, že počet alokovaných adres v prefixu překročí 50%, 75%, 90% a 95%, program tuto informaci zaloguje skrz standardní `syslog` mechanismus do logu následovně:
```bash
prefix x.x.x.x/y exceeded 50% of allocations
prefix x.x.x.x/y exceeded 75% of allocations
prefix x.x.x.x/y exceeded 90% of allocations
prefix x.x.x.x/y exceeded 95% of allocations
```
## Implementační detaily
Utilita **dhcp-stats** je napsána v programovacím jazyce `C`.\
Pro práci s *pcap* soubory a monitorování síťových rozhraní je v implementaci použita knihovna `libpcap`.\
Pro *syslog* se používá standardní logovací rutina `syslog`.\
Program **dhcp-stats** také předpokládá, že *pcap* soubor nebo síťové rozhraní bude mít k dispozici kompletní DHCP komunikaci, tj. jako kdyby byl nástroj spuštěn přímo na DHCP serveru.
## Seznam odevzdaných souborů
* `dhcp-stats.1` - soubor ve formátu a syntaxi manuálové stránky.
* `dhcp-stats.c` - zdrojový soubor v programovacím jazyce `C`.
* `dhcp-stats.h` - hlavičkový soubor v programovacím jazyce `C`.
* `Makefile` - funkční soubor pro překlad zdrojového souboru
* `manual.pdf` - soubor obsahující dokumentaci projektu ve formátu `PDF`.
* `README` - soubor ve formátu a syntaxi jazyka `Markdown`.
