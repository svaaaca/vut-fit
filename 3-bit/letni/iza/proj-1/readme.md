<!--
@file readme.md
@author David Kvaček (xkvace00@stud.fit.vutbr.cz)
@brief Readme file for the implementation of the application.
@date 2024-05-27
-->

# Dokumentace projektu z kursu IZA
**Jméno a příjmení:** David Kvaček (xkvace00@stud.fit.vutbr.cz)  
**Login:** `xkvace00`  
**Datum:** 27.05.2024

Implementační dokumentace popisuje aplikaci `cookbook`, která je výsledkem zadání projektu v rámci kursu Programování zařízení Apple (IZA 23/24L).
Aplikace slouží ke správě receptů a nákupního seznamu.
Uživatel si může vytvořit vlastní recepty s podrobnými informacemi o ingrediencích a postupu přípravy po jednotlivých krocích.
Pro vývoj a realizaci je využit jazyk Swift (SwiftUI) a k ukládání dat na serveru je použita databáze Firebase (Realtime Database).

## Struktura aplikace

Aplikace je rozdělena do několika karet, které jsou dostupné z hlavního menu nacházející se ve spodní části obrazovky.
Kostru aplikace tvoří pět karet, z nichž první čtyři se nachází v menu a detail je možné zobrazit stisknutím daného receptu v seznamu.

1. Hledat
2. Vytvořit
3. Oblíbené
4. Seznam
5. Detail

### Hledat

Karta *Hledat* slouží k vyhledávání a filtrování receptů podle názvu nebo různých kritérií.
Vyhledané recepty jsou zobrazeny v seznamu, kde je možné si vybrat jeden recept a zobrazit si jeho detail.
Uživatel je schopen filtrovat recepty podle druhu pokrmu, doby přípravy, nebo ingrediencí.
Je možné kombinovat hledání receptů podle názvu a zvolených kritérií.
V rámci zobrazeného seznamu lze recept odstranit z databáze pomocí gesta swipnutí zprava doleva.

### Vytvořit

Karta *Vytvořit* slouží k vytvoření nového receptu a jeho uložení do databáze.
Uživatel vyplní formulář s názvem receptu, druhem pokrmu a doby přípravy.
Následuje přidání jednotlivých ingrediencí (název, množství, jednotka) a kroků postupu přípravy (popis, čas).
Libovolně lze připojit obrázek ke každému receptu.

### Oblíbené

Karta *Oblíbené* zobrazuje seznam oblíbených receptů, které si uživatel označil srdcem.
Recepty jsou zobrazeny v seznamu, kde je možné si vybrat jeden recept a zobrazit si jeho detail.
Po zobrazení detailu receptu je možné recept odstranit z oblíbených receptů stisknutím tlačítka červeného srdce.

### Seznam

Karta *Seznam* slouží ke správě nákupního seznamu ingrediencí.
Uživatel si může vytvořit nový seznam, přidat do něj ingredience a následně je označit jako zakoupené.
Položky seznamu lze odstranit pomocí gesta swipnutí zprava doleva, nicméně pro hromadné odstranění všech položek je k dispozici tlačítko v pravém horním rohu obrazovky.

### Detail

Karta *Detail* zobrazuje podrobnosti o vybraném receptu včetně obrázku, druhu pokrmu, doby přípravy, ingrediencí a postupu přípravy.
Uživatel má možnost recept přidat nebo odebrat z oblíbených, nastavit si množství ingrediencí podle požadovaného počtu porcí, označit si jednotlivé ingredience jako připravené a přidat je přímo do nákupního seznamu jednoduchým tlačítkem.
Postup přípravy je zobrazen v podobě kroků, které je možné postupně procházet a označovat jako hotové.
U vybraných kroků, které obsahují časový údaj o době přípravy, je možné spustit časovač, jenž upozorní uživatele po uplynutí dané doby.

## Implementace

Aplikace je implementována v jazyce Swift s využitím SwiftUI.
Pro ukládání dat je použita databáze Firebase (Realtime Database).
Řešení je rozděleno do několika zdrojových souborů, které obsahují jednotlivé části aplikace.
Kostra aplikace je obsažena v souboru `cookbook.swift`, kde je zároveň implementována konfigurace databáze.
Spodní navigační lišta je implementována v souboru `navigation.swift`, kde je definováno hlavní menu aplikace.
Jednotlivé karty aplikace jsou v souborech `search.swift`, `create.swift`, `favorites.swift`, `list.swift` a `detail.swift`.
Soubor `shared.swift` obsahuje implementaci sdílené třídy pro práci s nákupním seznamem a jeho položkami.
Nedílnou součástí je také soubor s konfigurací databáze Firebase obsahující přístupové údaje k databázi.
