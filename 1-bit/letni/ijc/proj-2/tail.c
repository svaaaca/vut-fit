/**
 * The C Programming Language
 * ==========================
 * 
 * 2nd Project
 * Example: A
 * File: tail.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-04-20
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define OK 0
#define FAIL -1

int main(int argc, char *argv[]) {
    FILE * fileptr;
    int lines = 10, count, c, EOL, start, current, print;
    char * number;

    if(argc == 1) {
        EOL = 0;

        fileptr = fopen("a.txt", "w");
        if(!fileptr) {
            fprintf(stderr, "CHYBA: tail: Soubor 'a.txt' nelze otevrit\n");
            return FAIL;
        }

        while((c = fgetc(stdin)) != EOF) {
            if(c == '\n') {
                EOL++;
            }
            fputc(c, fileptr);
        }

        fclose(fileptr);
        fileptr = fopen("a.txt", "r");
        if(!fileptr) {
            fprintf(stderr, "CHYBA: tail: Soubor 'a.txt' nelze otevrit\n");
            return FAIL;
        }

        if(EOL <= lines) {
            fseek(fileptr, 0, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                printf("%c", c);
            }
        }

        else {
            start = EOL - lines;
            current = 0;
            fseek(fileptr, 0, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                if(c == '\n') {
                    current++;
                    if(current == start) {
                        print = ftell(fileptr);
                    }
                }
            }

            fseek(fileptr, print, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                printf("%c", c);
            }
        }

        fclose(fileptr);
        remove("a.txt");
    }

    else if(argc == 2) {
        fileptr = fopen(argv[1], "r");
        EOL = 0;

        if(!fileptr) {
            fprintf(stderr, "CHYBA: tail: Soubor '%s' nelze otevrit\n", argv[1]);
            return FAIL;
        }

        while((c = fgetc(fileptr)) != EOF) {
            if(c == '\n') {
                EOL++;
            }
        }

        if(EOL <= lines) {
            fseek(fileptr, 0, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                printf("%c", c);
            }
        }

        else {
            start = EOL - lines;
            current = 0;
            fseek(fileptr, 0, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                if(c == '\n') {
                    current++;
                    if(current == start) {
                        print = ftell(fileptr);
                    }
                }
            }

            fseek(fileptr, print, SEEK_SET);
            while((c = fgetc(fileptr)) != EOF) {
                printf("%c", c);
            }
        }

        fclose(fileptr);
    }

    else if(argc == 3) {
        if(strcmp(argv[1], "-n") == 0) {
            count = 0;
            number = argv[2];

            if(number[0] == '-') {
                count = 1;
            }

            while(number[count] != '\0') {
                if(number[count] < '0' || number[count] > '9') {
                    fprintf(stderr, "CHYBA: tail: Argument '%s' neni cislo\n", number);
                    return FAIL;
                }
                count++;
            }

            lines = atoi(number);
            if(lines < 0) {
                lines = ~lines + 1;
            }

            EOL = 0;

            fileptr = fopen("a.txt", "w");
            if(!fileptr) {
                fprintf(stderr, "CHYBA: tail: Soubor 'a.txt' nelze otevrit\n");
                return FAIL;
            }

            while((c = fgetc(stdin)) != EOF) {
                if(c == '\n') {
                    EOL++;
                }
                fputc(c, fileptr);
            }

            fclose(fileptr);
            fileptr = fopen("a.txt", "r");
            if(!fileptr) {
                fprintf(stderr, "CHYBA: tail: Soubor 'a.txt' nelze otevrit\n");
                return FAIL;
            }

            if(EOL <= lines) {
                fseek(fileptr, 0, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    printf("%c", c);
                }
            }

            else {
                start = EOL - lines;
                current = 0;
                fseek(fileptr, 0, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    if(c == '\n') {
                        current++;
                        if(current == start) {
                            print = ftell(fileptr);
                        }
                    }
                }

                fseek(fileptr, print, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    printf("%c", c);
                }
            }

            fclose(fileptr);
            remove("a.txt");
        }

        else {
            fprintf(stderr, "CHYBA: tail: Neplatny argument '%s'\n", argv[1]);
            return FAIL;
        }
    }

    else if(argc == 4) {
        if(strcmp(argv[1], "-n") == 0) {
            EOL = 0;
            count = 0;
            number = argv[2];

            if(number[0] == '-') {
                count = 1;
            }

            while(number[count] != '\0') {
                if(number[count] < '0' || number[count] > '9') {
                    fprintf(stderr, "CHYBA: tail: Argument '%s' neni cislo\n", number);
                    return FAIL;
                }
                count++;
            }

            lines = atoi(number);
            if(lines < 0) {
                lines = ~lines + 1;
            }
            
            fileptr = fopen(argv[3], "r");
            if(!fileptr) {
                fprintf(stderr, "CHYBA: tail: Soubor '%s' nelze otevrit\n", argv[3]);
                return FAIL;
            }

            while((c = fgetc(fileptr)) != EOF) {
                if(c == '\n') {
                    EOL++;
                }
            }

            if(EOL <= lines) {
                fseek(fileptr, 0, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    printf("%c", c);
                }
            }

            else {
                start = EOL - lines;
                current = 0;
                fseek(fileptr, 0, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    if(c == '\n') {
                        current++;
                        if(current == start) {
                            print = ftell(fileptr);
                        }
                    }
                }

                fseek(fileptr, print, SEEK_SET);
                while((c = fgetc(fileptr)) != EOF) {
                    printf("%c", c);
                }
            }

            fclose(fileptr);
        }

        else {
            fprintf(stderr, "CHYBA: tail: Neplatny argument '%s'\n", argv[1]);
            return FAIL;
        }
    }

    else if(argc > 4) {
        fprintf(stderr, "CHYBA: tail: Neplatny pocet argumentu [%d]\n", argc);
        return FAIL;
    }

    return OK;
}
