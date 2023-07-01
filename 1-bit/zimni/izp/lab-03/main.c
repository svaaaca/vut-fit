#include <stdio.h>
#include <stdlib.h>

int main()
{
    char str1[101];
    char str2[101];

    printf("Enter the first string: ");
    scanf("%100s", str1);
    printf("Enter the second string: ");
    scanf("%100s", str2);

    for (int i = 0; str1[i] != '\0'; i++){
        if (str1[i] != str2[i]){
            printf("Strings are not same.\n");
            return 1;
        }
    }
    printf("Strings are completely the same.\n");
    return 0;
}

