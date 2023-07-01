// #################################################################
// ##                                                             ##
// ## IZP - Zaklady programovani (ak. rok 2021/22, zimni semestr) ##
// ## Projekt 1 - Overovani sily hesel (prace s textem)           ##
// ##                                                             ##
// #################################################################
// ##                                                             ##
// ##                           AUTOR                             ##
// ## Login: xkvace00                                             ##
// ## Jmeno: Kvacek David                                         ##
// ## 1. rocnik BITP, prezencni                                   ##
// ##                                                             ##
// #################################################################

#include <stdio.h>
#include <stdlib.h>

// magicke konstanty max. delky hesla, rozdil hodnot velkych a malych pismen a velikost pole pro pocet ruznych znaku
#define MAX_LENGTH 102
#define DIFF 32
#define ASCII 128

typedef struct statistics // vlastni datovy typ (struktura) pro statistiky obsahujici tri hodnoty (pocet ruznych znaku, minimalni delka a prumerna delka)
{
    int NCHARS;
    int MIN;
    double AVG;
} stats_t;

stats_t stats = {0, MAX_LENGTH - 2, 0.0}; // inicializovani datoveho typu stats

// prototypy pouzitych funkci
int argv_check(char array[]);
int stats_check(char array[]);
int argv_value(char array[]);
int array_length(char array[]);
void clear_array(char array[]);
int level_1(char array[]);
int level_2(char array[], char argv[]);
int level_3(char array[], char argv[]);
int level_4(char array[], char argv[]);

int main(int argc, char *argv[])
{
    if (argc < 3) // osetreni vstupu pro pripad, kdy je zadany pocet argumentu mensi nez tri a odpovidajici chybove hlaseni
    {
        fprintf(stderr, "Neplatny pocet argumentu prikazove radky. Ukoncuji program...\n");
        return EXIT_FAILURE;
    }

    else if (argc == 3) // pripad, kdy je zadany pocet argumetu roven trem
    {
        if ((argv_check(argv[1]) < 1 || argv_check(argv[1]) > 4) || argv_check(argv[2]) < 1) // osetreni vstupu pro pripad, kdy je zadana nespravna hodnota argumentu
        {
            fprintf(stderr, "Neplatna hodnota argumentu prikazove radky. Ukoncuji program...\n");
            return EXIT_FAILURE;
        }

        else // pripad, kdy je zadana pozadovana hodnota argumentu
        {
            char password[MAX_LENGTH] = {0}; // pole pro ukladani aktualniho hesla o max. velikosti MAX_LENGTH, kde na kazde pozici je hodnota nula

            while ((fgets(password, MAX_LENGTH + 1, stdin)) != NULL) // cyklus, ktery umoznuje zadavat neomezeny pocet hesel (cyklus je ukoncen hodnotou EOF)
            {
                if (password[MAX_LENGTH - 1] != '\0') // osetreni vstupu pro pripad, kdy je zadano prilis dlouhe heslo
                {
                    fprintf(stderr, "Prilis dlouhe heslo. Ukoncuji program...\n");
                    return EXIT_FAILURE;
                }

                else // pokud ma heslo pozadovany pocet znaku, muze se s nim dale pracovat...
                {
                    if ((argv_check(argv[1])) == 1) // pripad, kdy je zadan level 1 (pokud je splnena podminka, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 2) // pripad, kdy je zadan level 2 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 3) // pripad, kdy je zadan level 3 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS && (level_3(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 4) // pripad, kdy je zadan level 4 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS && (level_3(password, argv[2])) == EXIT_SUCCESS && (level_4(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    clear_array(password); // po zpracovani kazdeho jednotliveho hesla se musi dane pole vycistit, aby bylo mozne zpracovat pripadne dalsi heslo
                }
            }
        }
    }

    else if (argc == 4) // pripad, kdy je zadany pocet argumetu roven ctyrem
    {
        if ((argv_check(argv[1]) < 1 || argv_check(argv[1]) > 4) || argv_check(argv[2]) < 1 || stats_check(argv[3]) == EXIT_FAILURE) // osetreni vstupu pro pripad, kdy je zadana nespravna hodnota argumentu
        {
            fprintf(stderr, "Neplatna hodnota argumentu prikazove radky. Ukoncuji program...\n");
            return EXIT_FAILURE;
        }

        else
        {
            char password[MAX_LENGTH] = {0}; // pole pro ukladani aktualniho hesla o max. velikosti MAX_LENGTH, kde na kazde pozici je hodnota nula
            int ascii[ASCII] = {0};          // pole pro pocitani ruznych znaku
            double count = 0.0, i = 0.0;     // promenne slouzici pro ukladani poctu znaku (int count) a poctu hesel (int i)
            int k, n = 0;                    // promenne slouzici pro prochazeni cyklu, ktery zjistuje pocet ruznych znaku v heslech

            while ((fgets(password, MAX_LENGTH + 1, stdin)) != NULL) // cyklus, ktery umoznuje zadavat neomezeny pocet hesel (cyklus je ukoncen hodnotou EOF)
            {
                if (password[MAX_LENGTH - 1] != '\0') // osetreni vstupu pro pripad, kdy je zadano prilis dlouhe heslo
                {
                    fprintf(stderr, "Prilis dlouhe heslo. Ukoncuji program...\n");
                    return EXIT_FAILURE;
                }

                else // pokud ma heslo pozadovany pocet znaku, muze se s nim dale pracovat...
                {
                    count += array_length(password); // k promenne count se pricte delka aktualniho hesla
                    i += 1;                          // k promenne i se pricte jedna, coz symbolizuje aktualni pocet hesel

                    if (array_length(password) < stats.MIN) // pokud je aktualni heslo mensi, nez je doposud ulozena hodnota v stats.MIN,
                        stats.MIN = array_length(password); // tak se do stats.MIN ulozi delka aktualniho hesla

                    for (k = 0; k < array_length(password); k++) // cyklus, ktery umoznuje zjistit pocet unikatnich znaku v heslech tak,
                        ascii[(int)password[k]] = 1;             // ze na pozici danou ASCII hodnotou znaku ulozi hodnotu jedna

                    if ((argv_check(argv[1])) == 1) // pripad, kdy je zadan level 1 (pokud je splnena podminka, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 2) // pripad, kdy je zadan level 2 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 3) // pripad, kdy je zadan level 3 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS && (level_3(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    else if ((argv_check(argv[1])) == 4) // pripad, kdy je zadan level 4 (pokud jsou splneny podminky, heslo se vypise)
                    {
                        if ((level_1(password)) == EXIT_SUCCESS && (level_2(password, argv[2])) == EXIT_SUCCESS && (level_3(password, argv[2])) == EXIT_SUCCESS && (level_4(password, argv[2])) == EXIT_SUCCESS)
                            printf("%s", password);
                    }

                    clear_array(password); // po zpracovani kazdeho jednotliveho hesla se musi dane pole vycistit, aby bylo mozne zpracovat pripadne dalsi heslo
                }
            }

            for (k = 0; k < ASCII; k++) // cyklus, ktery spocita pocet unikatnich znaku v heslech tak, ze spocita pocet
                n += ascii[k];          // ulozenych hodnot jedna

            stats.NCHARS = n; // prirazeni poctu ruznych znaku v heslech do stats.NCHARS

            if (i > 0)                 // pokud je pocet hesel vetsi nez nula
                stats.AVG = count / i; // vypocet prumerneho poctu znaku v heslech

            else // jinak se nastavi nasledujici hodnoty
            {
                stats.AVG = 0.0; // prumerny pocet znaku 0.0
                stats.MIN = 0;   // minimalni pocet znaku 0
            }

            printf("Statistika:\nRuznych znaku: %d\nMinimalni delka: %d\nPrumerna delka: %.1lf\n", stats.NCHARS, stats.MIN, stats.AVG); // vypis ze statistik
        }
    }

    else // osetreni vstupu pro pripad, kdy je zadany pocet argumentu jiny, tudiz nespravny a odpovidajici chybove hlaseni
    {
        fprintf(stderr, "Neplatny pocet argumentu prikazove radky. Ukoncuji program...\n");
        return EXIT_FAILURE;
    }

    return 0;
}

int argv_check(char array[]) // funkce, ktera zjistuje, zda argument obsahuje pouze cislice, ci nikoliv
{
    int c = 0, n = 0;

    for (int i = 0; i < array_length(array); i++) // cyklus, ktery prochazi argument
    {
        if (array[i] >= '0' && array[i] <= '9') // pokud je znak argumentu v rozmezi '0' az '9', zvysi se hodnota promenne c o jednicku
            c++;
    }

    if (c == array_length(array)) // pokud se hodnota c rovna delce argumentu, je jasne, ze argument se sklada pouze s cislic
    {
        n = atoi(array); // tim padem muzeme pouzit funkci atoi, ktera textovy retezec prevede na cislo
        return n;        // a funkce nasledne toto cislo vrati
    }

    else           // pokud se vsak c nerovna delce argumentu
        return -1; // funkce vrati -1
}

int stats_check(char array[]) // funkce, ktera porovnava textovy retezec '--stats' s tretim argumentem
{
    char stats[] = "--stats"; // deklarace textoveho retezce '--stats'
    int i = 0;                // promenna slouzici pro pruchod polem

    while (array[i] == stats[i]) // cyklus, ktery porovnava '--stats' se zadanym argumentem, dokud se retezce rovnaji
    {
        if (array[i] == '\0' || stats[i] == '\0') // pokud jeden retezec nepokracuje, skonci tim i cely cyklus
            break;

        i++; // jinak se zvysi hodnota i o jedna a cyklus pokracuje...
    }

    if (array[i] == '\0' && stats[i] == '\0') // nasleduje podminka, ktera zjisti, jestli jsou retezce stejne dlouhe
        return EXIT_SUCCESS;                  // a funkce tim padem skonci uspesne

    else
        return EXIT_FAILURE; // jinak skonci neuspesne
}

int argv_value(char array[]) // funkce, ktera vraci ciselnou hodnotu argumentu
{
    if ((argv_check(array)) == -1) // pokud se argument nesklada pouze z cislic
        return EXIT_FAILURE;       // funkce skonci neuspesne

    else
        return atoi(array); // jinak vrati ciselnou hodnotu argumentu
}

int array_length(char array[]) // funkce, ktera zjistuje delku pole
{
    int count = 0; // promenna slouzici pro pruchod polem

    for (count = 0; array[count] != '\n' && array[count] != '\0'; count++) // cyklus, ktery probiha do te doby, dokud nenarazi na prvek pole '\n' nebo '\0'
        ;
    return count; // a nasledna navratova hodnota funkce je pocet znaku daneho pole
}

void clear_array(char array[]) // funkce, ktera pouze vynuluje ('vycisti') pole a je tim padem datoveho typu void
{
    for (int i = 0; i <= MAX_LENGTH; i++) // cyklus, ktery prochazi pole od zacatku az do konce
        array[i] = '\0';                  // a vklada hodnotu '\0'
}

int level_1(char array[]) // funkce, ktera kontroluje level 1
{
    int capital_letters = 0, small_letters = 0; // promenne pro pocet velkych a malych pismen

    for (int i = 0; i < array_length(array); i++) // cyklus, ktery prochazi pole od zacatku do jeho delky
    {
        if (array[i] >= 'A' && array[i] <= 'Z') // pokud je znakem velke pismeno, zvysi se hodnota capital_letters o jedna
            capital_letters++;

        if (array[i] >= 'a' && array[i] <= 'z') // pokud je znakem male pismeno, zvysi se hodnota small_letters o jedna
            small_letters++;
    }

    if (capital_letters == 0 || small_letters == 0) // kdyz je alespon jedna z promennych rovna nule
        return EXIT_FAILURE;                        // funkce skonci neuspesne

    else
        return EXIT_SUCCESS; // jinak uspesne, jelikoz se v poli nachazi alespon jedno velke i male pismeno
}

int level_2(char array[], char argv[]) // funkce, ktera kontroluje level 2
{
    int capital_letters = 0, small_letters = 0, numbers = 0, special_characters = 0, count = 0; // promenne pro pocet velkych a malych pismen, cislic, specialnich znaku a souctu

    for (int i = 0; i < array_length(array); i++) // cyklus, ktery prochazi pole od zacatku do jeho delky
    {
        if (array[i] >= 'A' && array[i] <= 'Z') // pokud je znakem velke pismeno, zvysi se hodnota capital_letters o jedna
            capital_letters++;

        if (array[i] >= 'a' && array[i] <= 'z') // pokud je znakem male pismeno, zvysi se hodnota small_letters o jedna
            small_letters++;

        if (array[i] >= '0' && array[i] <= '9') // pokud je znakem cislice, zvysi se hodnota numbers o jedna
            numbers++;

        if ((array[i] >= ' ' && array[i] <= '/') || (array[i] >= ':' && array[i] <= '@') || (array[i] >= '[' && array[i] <= '`') || (array[i] >= '{' && array[i] <= '~'))
            special_characters++; // pokud je znakem specialni znak, zvysi se hodnota special_charcters o jedna
    }

    if (capital_letters > 0) // kdyz pole obsahuje alespon jedno velke pismeno, tak se soucet zvysi o jedna
        count++;

    if (small_letters > 0) // kdyz pole obsahuje alespon jedno male pismeno, tak se soucet zvysi o jedna
        count++;

    if (numbers > 0) // kdyz pole obsahuje alespon jednu cislici, tak se soucet zvysi o jedna
        count++;

    if (special_characters > 0) // kdyz pole obsahuje alespon jednen specialni znak, tak se soucet zvysi o jedna
        count++;

    if ((argv_value(argv)) == 1) // pripad, kdy je argument jedna
    {
        if (count < 1)           // pokud je count mensi nez jedna
            return EXIT_FAILURE; // funkce skonci neuspesne

        else
            return EXIT_SUCCESS; // jinak skonci uspesne
    }

    else if ((argv_value(argv)) == 2) // pripad, kdy je argument dva
    {
        if (count < 2)           // pokud je count mensi nez dva
            return EXIT_FAILURE; // funkce skonci neuspesne

        else
            return EXIT_SUCCESS; // jinak skonci uspesne
    }

    else if ((argv_value(argv)) == 3) // pripad, kdy je argument tri
    {
        if (count < 3)           // pokud je count mensi nez tri
            return EXIT_FAILURE; // funkce skonci neuspesne

        else
            return EXIT_SUCCESS; // jinak skonci uspesne
    }

    else if ((argv_value(argv)) >= 4) // pripad, kdy je argument ctyri nebo vetsi
    {
        if (count < 4)           // pokud je count mensi nez ctyri
            return EXIT_FAILURE; // funkce skonci neuspesne

        else
            return EXIT_SUCCESS; // jinak skonci uspesne
    }

    else
        return EXIT_FAILURE; // jinak funkce skonci neuspesne
}

int level_3(char array[], char argv[]) // funkce, ktera kontroluje level 3
{
    int k = argv_value(argv); // promenna, do ktere se ulozi hodnota argumentu PARAM
    int count;                // promenna, ktera urcuje pocet stejnych znaku

    if (k == 1) // pripad, kdy je hodnota argumentu PARAM rovna jedne
    {
        for (int i = 0; i < array_length(array); i++) // cyklus, ktery prochazi pole od zacatku do jeho delky
        {
            count = 0;                              // hodnota count je nastavena na nulu
            for (int j = (i + 1); j < (i + k); j++) // cyklus, ktery prochazi pole od (i + 1). prvku do (i + k). prvku
            {
                if (array[i] == array[j] + DIFF) // pokud se i. prvek pole rovna j. prvku pole zvetseneho o rozdil maleho a velkeho pismene
                    count++;                     // zvysi se hodnota promenne count o jedna

                else if (array[i] == array[j] - DIFF) // pokud se i. prvek pole rovna j. prvku pole zmenseneho o rozdil maleho a velkeho pismene
                    count++;                          // zvysi se hodnota promenne count o jedna
            }

            if ((count + 1) == k)    // kdyz se hodnota promenne count zvetsene o jedna rovna hodnote argumentu PARAM
                return EXIT_FAILURE; // tak funkce skonci neuspesne
        }
    }

    else // pripad, kdy je hodnota argumentu PARAM rozdilna od jedne
    {
        for (int i = 0; i < (array_length(array)); i++) // cyklus, ktery prochazi pole od zacatku do jeho delky
        {
            count = 0;                              // hodnota count je nastavena na nulu
            for (int j = (i + 1); j < (i + k); j++) // cyklus, ktery prochazi pole od (i + 1). prvku do (i + k). prvku
            {
                if (array[i] == array[j]) // pokud se i. a j. prvek pole rovnaji,
                    count++;              // zvysi se hodnota promenne count o jedna
            }

            if ((count + 1) == k)    // kdyz se hodnota promenne count zvetsene o jedna rovna hodnote argumentu PARAM
                return EXIT_FAILURE; // tak funkce skonci neuspesne
        }
    }

    return EXIT_SUCCESS; // jinak skonci uspesne
}

int level_4(char array[], char argv[]) // funkce, ktera kontroluje level 4
{
    int i, j;     // promenne slouzici pro pruchod polem
    int same = 0; // promenna slouzici pro ukladani poctu stejnych podretezcu

    for (i = 0; i < (array_length(array)) - 1; i++) // cyklus, ktery prochazi pole od zacatku do jeho delky zmensene o jedna
    {
        for (j = (i + 1); j < array_length(array); j++) // cyklus, ktery prochazi pole od (i + 1). prvku do jeho delky
        {
            if (array[i] == array[j]) // pokud se i. a j. prvek pole rovnaji, tak
            {
                same = 0;                                                                               // je hodnota same nastavena na nulu
                for (int a = i; a < (i + argv_value(argv)) && (a + (j - i)) < array_length(array); a++) // a dalsi cyklus tentokrat prochazi pole od i. prvku bud do (i + hodnota argumentu PARAM). prvku, nebo do jeho delky
                {
                    if (array[a] == array[a + (j - i)]) // pokud se a. prvek pole rovna (a + (j - i)). prvku pole, tak
                        same++;                         // se hodnota promenne same zvysi o jedna
                }

                if (same >= argv_value(argv)) // pokud je hodnota promenne same vetsi nebo rovna hodnote argumentu PARAM, tak
                    return EXIT_FAILURE;      // funkce skonci neuspesne
            }
        }
    }

    return EXIT_SUCCESS; // jinak skonci uspesne
}
