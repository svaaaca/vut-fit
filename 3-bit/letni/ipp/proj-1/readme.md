<!--
@file readme1.md
@author David Kvaček (xkvace00@stud.fit.vutbr.cz)
@brief Documentation of the code analyzer in IPPcode24 (parser) implementation.
@date 2024-03-04
-->

## Implementační dokumentace k 1. úloze do IPP 2023/2024  
**Jméno a příjmení:** David Kvaček  
**Login:** `xkvace00`  

### Přehled

Implementační dokumentace popisuje skript `parse.py`, který je výsledkem zadání první úlohy v rámci kursu IPP 2023/2024.
Program slouží k analýze zdrojového kódu v jazyce *IPPcode24* (standardní vstup) a výsledkem je jeho XML reprezentace na standardním výstupu.
Pro vývoj a realizaci je využit jazyk Python ve verzi 3.10.

### Zpracování parametrů příkazové řádky

Prvním krokem při vykonávání skriptu je zpracování parametrů příkazové řádky.
Všechny parametry v podobě seznamu jsou předány funkci `args_check()`, která zajišťuje kontrolu správnosti případně zadaných parametrů, jejich počtu, pořadí, či kombinace.
Pokud je nalezena chyba, je vyvolána výjimka `ParameterError` s odpovídající chybovou hláškou a návratovým kódem `10`.

Jelikož je registrováno jedno z rozšíření, konkrétně STATP (sbírání statistik), které podporuje několik parametrů, je k jejich pohodlnějšímu zpracování využit modul `argparse`.

### Analýza zdrojového kódu

Po úspěšném zpracování parametrů příkazové řádky je následně načten zdrojový kód ze standardního vstupu pomocí metody `sys.stdin.readlines()`, která uloží do proměnné celý vstupní zdrojový kód jako seznam jednotlivých řádků.

Po načtení zdrojového kódu následují především specifické lexikální a syntaktické kontroly v rámci definovaných funkcí `header_check()` (korektní formát hlavičky), `opcode_check()` (korektní formát operačních kódů, přesněji jednotlivých instrukcí) a `operand_check()` (korektní formát instrukčních operandů), které využívají další pomocné funkce pro kontrolu korektního formátu proměnných, návěští, konstant a typů pomocí regulárních výrazů (modul `re`).

Do těchto funkcí je předáván vstupní zdrojový kód v takové podobě, že již neobsahuje žádné přebytečné (prázdné/zakomentované) řádky, komentáře, či bílé znaky na začátku a konci řádků.
Tento proces zajišťuje funkce `clean_code()`, která k tomu využívá regulární výrazy.

### Výstupní XML reprezentace

Výsledná XML reprezentace je vytvářena pomocí modulů `xml.dom.minidom` a `xml.etree.ElementTree` a jejich metod pro vytváření XML elementů, atributů a textových uzlů.

Výsledný XML dokument je vytvořen v paměti a následně je pomocí funkce `xml.etree.ElementTree.tostring()` převeden do řetězce, který je poté vytisknut na standardní výstup.
K formátování XML dokumentu je využita metoda `xml.dom.minidom.toprettyxml()`.

### Výjimky a návratové kódy

V rámci skriptu jsou definovány vlastní výjimky, které jsou vyvolány v případě chybného formátu vstupních parametrů, chybného formátu zdrojového kódu, či jiných chyb.

Výjimky jsou odchytávány v hlavním těle skriptu a v případě, že je některá vyvolána, je vytisknuta odpovídající chybová hláška na standardní chybový výstup a skript je ukončen s odpovídajícím návratovým kódem.

### Rozšíření STATP (sbírání statistik)

Jedním z rozšíření, které je implementováno, je sbírání jednotlivých statistik o zpracovaném zdrojovém kódu.
Statistiky jsou generovány až po úspěšném zpracování celého zdrojového kódu a jsou vytisknuty do uživatelem zadaných souborů pomocí parametrů `--stats=file`.

Podstatná část funkčnosti tohoto rozšíření je implementována ve funkci `generate_stats()`, která postupně prochází parametry příkazové řádky a na jejich základě vytváří či modifikuje zadaný soubor, nebo již tiskne samotnou skupinu statistik.

Pro výpočet číselné hodnoty některých statistik jsou využity pomocné funkce s odpovídajícími názvy, které procházejí zdrojový kód a počítají jednotlivé údaje.