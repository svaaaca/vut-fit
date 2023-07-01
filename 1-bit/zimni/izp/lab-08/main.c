#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Initial string content
const char *str_init = "Hello World!";

// Find first substring occurrence in a string and return its starting position.
// Return -1 if the string does not contain substring.
int find_substr(char *str, char *substr) {
    for (int i = 0; str[i] != '\0'; i++) {
        for (int j = 0; str[i + j] == substr[j]; j++) {
            if(substr[j + 1] == '\0') {
                return i;
            }
        }
    }
    return -1;
}

// Replace same-length substrings in a string.
void replace_same_length(char *str, char *substr, char *new_substr) {
    int index = find_substr(str, substr);
    if (index == -1) {
        return;
    }
    else {
        for (int i = 0; new_substr[i] != '\0'; i++) {
            str[index + i] = new_substr[i];
        }
    }
}


// Replace substring in a string with any new substring.
// Returns new string with replaced substring or NULL in case of any error.
char *replace(char *str, char *substr, char *new_substr) {
    int index = find_substr(str, substr);
    if (index == -1) {
        return NULL;
    }
    else {
        int str_length = strlen(str);
        int substr_length = strlen(substr);
        int new_substr_length = strlen(new_substr);
        int new_length = substr_length - new_substr_length;

        if (new_length) {
            char *new_str = (char *)realloc(str, str_length - new_length + 1);
            if (new_str == NULL) {
                return NULL;
            }
            str = new_str;
        }
    }
    return str;
}


int main() {
    // Allocate new string.
    char *str = (char *)malloc(strlen(str_init) + 1);
    if (str == NULL) {
        return 1;
    }
    // Set the initial string by copying it.
    strcpy(str, str_init);

    // Replace substring with a new same-length substring.
    replace_same_length(str, "World!", "worlds");
    printf("%s\n", str);

    // Replace substring with a new shorter substring.
    str = replace(str, "worlds", "IZP!");
    if (str == NULL) {
        return 1;
    }
    printf("%s\n", str);

    // Replace substring with a new longer substring.
    str = replace(str, "IZP!", "World!");
    if (str == NULL) {
        return 1;
    }
    printf("%s\n", str);

    // Cleanup
    free(str);
    printf("Successully replaced all substrings!\n");

    // Allocate and initialize a new string.
    str = (char *)malloc(strlen(str_init) + 1);
    if (str == NULL) {
        return 1;
    }
    strcpy(str, str_init);

    // Try using replace with substring that is not in the string.
    str = replace(str, "worlds", "World!");
    if (str == NULL) {
        return 1;
    }
    printf("%s\n", str);

    return 0;
}

