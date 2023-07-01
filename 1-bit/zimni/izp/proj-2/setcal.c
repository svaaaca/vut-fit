// #################################################################
// ##                                                             ##
// ## IZP - Zaklady programovani (ak. rok 2021/22, zimni semestr) ##
// ## Projekt 2 - Prace s datovymi strukturami                    ##
// ##                                                             ##
// #################################################################
// ##                                                             ##
// ##                           AUTORI                            ##
// ##                                                             ##
// ## Login: xjemel07                                             ##
// ## Jmeno: Jemelik Ondrej                                       ##
// ##                                                             ##
// ## Login: xkvace00                                             ##
// ## Jmeno: Kvacek David                                         ##
// ##                                                             ##
// ## Login: xzdraz14                                             ##
// ## Jmeno: Zdrazilek Lukas                                      ##
// ##                                                             ##
// ## Login: xzouha14                                             ##
// ## Jmeno: Zouhar Petr                                          ##
// ##                                                             ##
// ## 1. rocnik BITP, prezencni                                   ##
// ##                                                             ##
// #################################################################

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define OK 0          // uspesne ukonceni programu
#define FAIL -1       // neuspesne ukonceni programu
#define MAX_LENGTH 31 // maximalni delka retezce
#define NREL 2        // pocet clenu relace
#define MAX_SIZE 1000 // maximalni pocet znaku a radku
#define ID 21         // pocet kontrolovanych identifikatoru

int line_type(char array[]);
int line_split(char array[]);
int line_check(char array[]);
int line_char(char array[]);
int line_length(char array[]);
int member_count(char array[]);
int member_length(char array[]);
void clear_array(char array[]);

typedef struct universe // datova struktura pro univerzum
{
    int id;
    char *member[MAX_LENGTH];
    int size;
} uni_t;

typedef struct set // datova struktura pro mnoziny
{
    int id;
    char *member[MAX_LENGTH];
    int size;
} set_t;

typedef struct relation // datova struktura pro relace
{
    int id;
    char *member[MAX_LENGTH][NREL];
    int size;
} rel_t;

// ########################FUNKCE PRO MNOZINY#######################

void card(set_t *set){        // Vypise pocet prvku v mnozine
    printf("\n%d",set->size);
}

int empty(set_t *set){       // Vrati 1 / 0 pokud je prazdny / neni prazdny
    if ( *set->member[0] == '\0'){
        return 1;
    }
    else {
        return 0;
    }
}

int equals(set_t *seta, set_t *setb){       // Vrati 1 / 0 pokud jsou mnoziny / universum stejne / nejsou stejne, plati pouze
    int i, j, k = 0;                        // pro samotnou mnozinu, ne cely struct
    if (*seta->member[0] == '\0' && *setb->member[0] == '\0'){
        return 1;           // pokud jsou obe prazdne = 1 jsou stejne
    }
    else if (*seta->member[0] == '\0' && *setb->member[0] != '\0'){
        return 0;           // pokud je pouze jedna prazdna = 0 nejsou stejne
    }
    else if (*seta->member[0] != '\0' && *setb->member[0]  == '\0'){
        return 0;           // pokud je pouze druha prazdna = 0
    }
    else if (seta->size > setb->size || setb->size > seta->size){
        return 0;           // pokud je jedna delsi nez druha a naopak = 0
    }    
    else {
        for ( i = 0, j = 0; i < seta->size && j < setb->size;){
           if ( strcmp( seta->member[i], setb->member[j]) == 0){
               k++;
               i = 0;       // porovnavani kazdeho prvku zda jsou stejne (i v ruznem poradi)
               j++;
           }
           else {
               i++;
           }
        }
    if ( j == seta->size){
        return 1;    
    }
    else {
        return 0;
        }
    } return 0;
}

void intersect(set_t *seta, set_t *setb){       // Vypise ty prvky, ktere maji dve mnoziny / universum spolecne
    int i, j = 0;
    printf("Intersect: ");
    for ( i = 0; i < seta->size; i++){
        for ( j = 0; j < setb->size; j++){
            if ( strcmp(seta->member[i], setb->member[j]) == 0){
                printf("%s ", seta->member[i]);
                break;
            }
        }
    }
}

void complement(set_t *seta, uni_t *uni){   // Vypise ty prvky, ktere mnozine vuci universu chybi      
    printf("\nComplement: ");
    int i, j, l = 0;
    if ( empty( seta) == 1){
        for ( i = 0; i < uni->size; i++){    // vypise cele universum, protoze je mnozina prazdna
            printf("%s ", uni->member[i]);
        }
    }
    else if ( *uni->member[0] == '\0'){
        printf("ERROR, mnozina bez universa");    // vrati chybu, nemuze byt mnozina bez universa
    }    
    else if ( empty( seta) == 1 && *uni->member[0] == '\0'){
        printf("0");                              // vrati 0 protoze mnozina i universum jsou nulove (teoreticky to jde)
    }
    else {    
        for ( i = 0, j = 0; i < uni->size && j < seta->size;){      // porovnavani prvku po prvku
            if ( strcmp( uni->member[i], seta->member[j]) == 0){
                i++;
                j = 0;
                l = 0;
            }
            else if ( strcmp( uni->member[i], seta->member[j]) != 0){
                l++;
                j++;
                if (j == uni->size){
                    j = 0;
                }
                if (l == uni->size){
                    printf("%s ", uni->member[i]);
                    i++;
                    l = 0;
                }
            }   
        }    
    }  
}

void set_union(set_t *seta, set_t *setb){       // Vypise vsechny prvky ze dvou mnozin (kazdy pouze jednou)
    printf("\nUnion: ");
    int i, j, k = 0;
    char* pomocna[1000];
    if ( empty(seta) == 1){                     // kdyz je prvni mnozina prazdna, vypise celou druhou 
        for ( i = 0; i < setb->size; i++){
            pomocna[i] = setb->member[i];
            k++;
        }
    }
    else if ( empty(setb) == 1){
        for ( i = 0; i < seta->size; i++){      // kdyz je druha mnozina prazdna, vypise celou prvni
            pomocna[i] = seta->member[i];
            k++;
        }
    }
    else if (empty(seta) == 1 && empty(setb) == 1){     // kdyz jsou obe prazdne, vypise nulu
        pomocna[0] = 0;      
        k = 1;
    }
    else if ( equals(seta, setb) == 1){                 // kdyz se obe rovnaji, vypise jednu z nich
        for ( i = 0; i < seta->size; i++){
            pomocna[i] = seta->member[i];
            k++;
        }
    }
    else {
        for ( i = 0; i < seta->size; i++){              // porovnavani prvku po prvku
            pomocna[i] = seta->member[i];
            k++;
        }
        for (i = 0, j = 0; i < k && j < setb->size;){
            if ( strcmp( pomocna[i], setb->member[j]) == 0){
                j++;
                i = 0;
            }
            else if ( strcmp( pomocna[i], setb->member[j]) != 0){
                i++;
                if (i == k){
                    pomocna[k] = setb->member[j];
                    i = 0;
                    j++;
                    k++;
                }
            }
        }
    } 
    int m;                          // vypsani pomocne mnoziny do ktere se ukladaly vysledky funkce
    for (m = 0; m < k ; m++){       // v cas kdy jsem to delal mi to prislo jednodussi reseni
    printf(" %s", pomocna[m]);   
    }   
}

void minus(set_t *seta, set_t *setb){     // Vypise mnozinu a bez prvku mnoziny b
    char* pomocna1[1000];
    int i, j, k = 0;
    printf("\nMinus:");
    if ( empty(seta) == 1){               // pokud je a prazdna, vypise nulu, nemaji spolecne prvky
        printf("0"); 
    }
    else if ( empty(setb) == 1){          // pokud je b prazdna, vypise a, a - 0 = a
        for (i = 0; i < seta->size; i++)
        printf(" %s", seta->member[i]); 
    }
    else if ( empty(seta) == 1 && empty(setb) == 1){    // pokud jsou obe prazdne, vypise nulu, 0 - 0 = 0
        printf("0");
    }
    else if ( equals(seta, setb) == 1){                 // pokud se a i b rovnaji, vypise nulu, odecetly se od sebe
        printf("0"); 
    }
    else {                                              // porovnavani prvku po prvku ( jsou-li ruzne nebo v ruznem poradi)
        for ( i = 0, j = 0; i < seta->size && j < setb->size;){     
            if ( strcmp( seta->member[i], setb->member[j]) == 0){
                i++;
                j = 0;
            }
            else if ( strcmp( seta->member[i], setb->member[j]) != 0){
                j++;
                if (j == seta->size){
                    pomocna1[k] = seta->member[i];
                    j = 0;
                    i++;
                    k++;
                }
            }   
        }
        int m;
        for (m = 0; m < k ; m++){           // vypsani pomocne mnoziny do ktere se ukladaly vysledky funkce
        printf(" %s", pomocna1[m]); 
        }
    }
}

void subseteq(set_t *seta, set_t *setb){  // Mnozina a je podmnozinou b, mohou byt stejne
    int i, j, k = 0;
    printf("\nSubseteq: ");
    if ( empty(seta) == 1){               // mnozina a je prazdna, b neni, nemuze byt podmnozinou
        printf("FALSE");                
    }
    else if ( empty(setb) == 1){        // mnozina b je prazdna, a neni, nemuze byt podmnozinou
        printf("FALSE");
    }
    else if ( empty(seta) == 1 && empty(setb) == 1){
        printf("TRUE");                // obe jsou prazdne a stejne, teoreticky muze byt podmnozinou
    }
    else if ( equals(seta, setb) == 1){     // obe jsou stejne, dle zadani muze byt podmnozinou
        printf("TRUE");
    }
    else{                                   // porovnavani prvku po prvku
        for (i = 0, j = 0; i < setb->size && j < seta->size;){
            if ( strcmp( setb->member[i], seta->member[j]) == 0){
                k++;
                j++;
                i = 0;
                if ( j == seta->size){
                    break;
                }
            }
            else if ( strcmp( setb->member[i], seta->member[j]) != 0){
                i++;
            }
        }
        if ( k == seta->size){
        printf("TRUE"); 
        }
        else {
            printf("FALSE");
        }
    }
}

void subset(set_t *seta, set_t *setb){    // Mnozina a je podmnozinou b, nemohou byt stejne
    int i, j, k = 0;
    printf("\nSubset: ");               // mnozina a je prazdna, b neni, nemuze byt podmnozinou
    if ( empty(seta) == 1){
        printf("FALSE");                
    }
    else if ( empty(setb) == 1){        // mnozina b je prazdna, a neni, nemuze byt podmnozinou
        printf("FALSE");
    }
    else if ( empty(seta) == 1 && empty(setb) == 1){    // obe jsou prazdne a stejne, dle zadani nemuze byt podmnozinou
        printf("FALSE"); 
    }
    else{                                       // // obe jsou stejne (i ruzne poradi), dle zadani nemuze byt podmnozinou
        for (i = 0, j = 0; i < setb->size && j < seta->size;){      // kontrola prvku po prvku
            if ( strcmp( setb->member[i], seta->member[j]) == 0){
                k++;
                j++;
                i = 0;
                if ( j == seta->size){
                    break;
                }
            }
            else if ( strcmp( setb->member[i], seta->member[j]) != 0){
                i++;
            }
        }
        if ( k == seta->size && setb->size != seta->size){
        printf("TRUE");
        }
        else if (k == seta->size && setb->size == seta->size) {
            printf("FALSE");
        }
        else {
            printf("FALSE");
        }
    }
}

// #################################################################
int reflexive(rel_t *rel, uni_t *uni)  
{
    int realsize = 0;
    int l,k,j,i,pocet = 0;
    for (k = 0; k < uni->size; k++)
    {
        for (j = 0; j < uni->size; j++)
        {   for (l = 0; l < 2; l++)
            {
                if (strcmp(rel->member[j][l], uni->member[k])==0)       //zjisti kolik prvku univerza je pouzito v relaci
                {
                    realsize++;
                    k++;
                    l=0;
                    j=0;
                }
            }    
        } 
    }
    
    for (i = 0; i < rel->size; i++){
        if ( strcmp( rel->member[i][0], rel->member[i][1]) == 0){   //zjisti pocet relací co jsou v relaci samy se sebou
            pocet++;
        }
        if ( pocet == realsize){
            return 1;
        }
        else {
            return 0;
        }
    }
    return 0;
}

int symmetric( rel_t *rel){         // (Apple Banana) (Banana Apple) (Apple Apple)
    int i, j = 0;
    for (i = 0, j = 0; i < rel->size && j < rel->size;){
        if (( strcmp( rel->member[i][0], rel->member[i][1]) != 0) && (j != rel->size)){
            i++;
            j++;
        }
        else if ( strcmp( rel->member[i][0], rel->member[rel->size][1]) != 0){
            return 0;
        }
        else {
            if ( strcmp( rel->member[i][0], rel->member[i][1]) == 0){
            break;
            }
            else {
                i++;
                j++;
            }
        } 
    }
    return 1;
}


int antisymmetric(rel_t *rel)   //Relace je antisimetrická, pokud je a v relaci s b && b není v relaci s a
{
    int i, j, pocet = 0;
    for ( i = 0; i < rel->size; i++) {
        for ( j = i+1; j < rel->size; j++){
            if ((strcmp( rel->member[i][0], rel->member[j][1]) == 0) && (strcmp( rel->member[i][1], rel->member[j][0]) == 0)){
                pocet++;
            }
        }
    }
    if( pocet > 0) {
        return 0;
    } else 
        {
        return 1;
        }
    
}


int funkcion(rel_t *rel)    //relace je funkcí, pokud má kazdé a jenom jedno b
{
    int i,j;
    for (i = 0; i < rel->size; i++)
    {
        for (j = 0; j < rel->size; j++)
        {
            if (strcmp(rel->member[i][0],rel->member[j][0]) == 0 && strcmp(rel->member[i][1],rel->member[j][1]) != 0)
            {
                return 0;
            }  
        } 
    }
    return 1; 
}

//void domain()


//void codomain()

//void injective(rel_t *rel)

//void surjective()

//void bijective() 
// ################################################################

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Neplatny pocet argumentu prikazove radky. Ukoncuji program...\n");
        return FAIL;
    }

    else
    {
        FILE *fptr = fopen(argv[1], "r");
        if (fptr)
        {
            char tmp[MAX_SIZE];
            int lines = 0;

            while (fgets(tmp, MAX_SIZE, fptr))
            {
                lines++;
                if (lines > MAX_SIZE)
                {
                    fprintf(stderr, "Prekrocen maximalni pocet radku! Ukoncuji program...\n");
                    return FAIL;
                }

                if (line_type(tmp) == FAIL)
                {
                    fprintf(stderr, "Nepodporovany format vstupnich dat! Ukoncuji program...\n");
                    return FAIL;
                }

                if (line_type(tmp) != 5)
                {
                    if (line_char(tmp) == FAIL)
                        return FAIL;
                    
                    printf("%s", tmp);

                    if (line_split(tmp) == FAIL)
                        return FAIL;
                }
            }

            fclose(fptr);
        }

        else
        {
            fprintf(stderr, "Zadany nazev souboru je neplatny! Ukoncuji program...\n");
            return FAIL;
        }
    }

    return OK;
}

// #################################################################

int line_type(char array[]) // funkce, ktera zjistuje, o jaky typ radku se jedna
{
    if (array[0] == 'U' && array[1] == ' ' && array[2] != '\n')
        return 1;

    else if (array[0] == 'S' && array[1] == ' ' && array[2] != '\n')
        return 2;

    else if (array[0] == 'R' && array[1] == ' ' && array[2] != '\n')
        return 3;

    else if (array[0] == 'U' && array[1] == ' ' && array[2] == '\n')
        return 4;

    else if (array[0] == 'S' && array[1] == ' ' && array[2] == '\n')
        return 4;

    else if (array[0] == 'R' && array[1] == ' ' && array[2] == '\n')
        return 4;

    else if (array[0] == 'U' && array[1] == '\n')
        return 4;

    else if (array[0] == 'S' && array[1] == '\n')
        return 4;

    else if (array[0] == 'R' && array[1] == '\n')
        return 4;

    else if (array[0] == 'C' && array[1] == ' ' && array[2] != '\n')
        return 5;

    else
        return FAIL;
}

int line_split(char array[]) // funkce, ktera rozdeli cely radek na jednotlive cleny
{
    int i = 0;
    char dividers[] = " ()\n";
    char *ptr = strtok(array, dividers);

    while (ptr != NULL)
    {
        if (member_length(ptr) == FAIL)
        {
            fprintf(stderr, "Prekrocena maximalni delka retezce! Ukoncuji program...\n");
            return FAIL;
        }

        if (line_check(ptr) == FAIL)
            return FAIL;

        ptr = strtok(NULL, dividers);
        i++;
    }

    return OK;
}

int line_check(char array[]) // funkce, ktera zjistuje, jestli se v clenu nevyskytuje identifikator
{
    char check[ID][MAX_LENGTH] = {"true", "false", "empty", "card", "complement", "union", "intersect", "minus", "subseteq", "subset", "equals", "reflexive", "symmetric", "antisymmetric", "transitive", "function", "domain", "codomain", "injective", "surjective", "bijective"};
    int same = 0;

    for (int i = 0; i < ID; i++)
    {
        if (strcmp(check[i], array) == 0)
            same++;
    }

    if (same == 0)
        return OK;
    else
    {
        fprintf(stderr, "Chybny vyskyt identifikatoru! Ukoncuji program...\n");
        return FAIL;
    }
}

int line_char(char array[]) // funkce, ktera zjistuje, jestli clen obsahuje pouze mala nebo velka pismena
{
    int i, capital = 0, small = 0, space = 0, bracket = 0;
    for (i = 0; array[i] != '\n' && array[i] != '\0'; i++)
    {
        if (array[i] >= 'A' && array[i] <= 'Z')
            capital++;

        if (array[i] >= 'a' && array[i] <= 'z')
            small++;

        if (array[i] == ' ')
            space++;

        if (array[i] == '(' || array[i] == ')')
            bracket++;
    }

    if (line_type(array) == 1 || line_type(array) == 2)
    {
        if ((capital + small + space) == i)
            return OK;

        else
        {
            fprintf(stderr, "Chybny znak v retezci! Ukoncuji program...\n");
            return FAIL;
        }
    }

    if (line_type(array) == 3)
    {
        if ((capital + small + space + bracket) == i)
            return OK;

        else
        {
            fprintf(stderr, "Chybny znak v retezci! Ukoncuji program...\n");
            return FAIL;
        }
    }

    return OK;
}

int member_count(char array[]) // funkce, ktera vypocita pocet clenu na radku
{
    int count = 0;
    for (int i = 0; array[i] != '\0'; i++)
    {
        if (array[i] == ' ' && array[i + 1] != ' ')
            count++;
    }

    if (line_type(array) == 4)
        return 0;

    else
        return count;
}

int member_length(char array[]) // funkce, ktera zjistuje delku jednoho clenu
{
    int length = 0;
    for (int i = 0; array[i] != '\0' && array[i] != '\n'; i++)
        length++;

    if (length < MAX_LENGTH)
        return length;

    else
        return FAIL;
}

void clear_array(char array[]) // funkce, ktera vynuluje pole
{
    int length = strlen(array);
    for (int i = 0; i < length; i++)
        array[i] = 0;

    return;
}
