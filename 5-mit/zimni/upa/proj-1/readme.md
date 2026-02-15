# Projekt, 1. část: extrakce dat z webu

**Název týmu:** Tým xkaska02

**Řešitelé:**
- Martin Burian (xburiam00)
- Karel Kaska (xkaska02)
- David Kvaček (xkvace00)

**Zvolený e-shop:**
- Otomoto (https://www.otomoto.pl/)

**Obsahu archivu:**
- `build.sh` – skript zajišťující překlad, instalaci závislostí a další úkony nezbytné pro běh programů,
- `fetcher.py` – skript, který získá seznam URL produktů z e-shopu a uloží je do souboru `urls.txt`,
- `data.tsv` – ukázkový výstup skriptu `scraper.py` ve formátu TSV,
- `run.sh` – testovací skript, který spustí skript pro získání seznamu URL produktů, uloží je do souboru `url_test.txt` a následně pro prvních 10 URL z tohoto seznamu spustí druhý skript, který získá informace o produktech a vypíše je na standardní výstup (stdout),
- `scraper.py` – skript, který pro URL produktu získá informace o produktu a vypíše je ve formátu TSV na standardní výstup (stdout),
- `urls.txt` – ukázkový výstup skriptu `fetcher.py`, na každém řádku 1 URL.

**Význam sloupců ve výstupu TSV:**
1. URL produktu,
2. název produktu,
3. cena produktu (PLN),
4. značka automobilu,
5. model automobilu,
6. barva automobilu (polsky),
7. počet dveří,
8. počet sedadel,
9. rok výroby.

**Poznámky k řešení:**

V případě že daná stránka neobsahuje konkrétní atribut, je jeho hodnota ve výsledném TSV souboru uložena jako prázdný řetězec. 
