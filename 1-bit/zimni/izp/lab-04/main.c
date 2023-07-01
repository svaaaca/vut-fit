#include <stdio.h>
#include <stdlib.h>

int main()
{
    int arr1[] = {1, 2, 3, 4, 5};
    int arr2[] = {6, 7, 8, 9, 10};
    int len1 = 5;
    int len2 = 5;

    for(int i = 0; i < len1; i++){
        for(int j = 0; j < len2; j++)
        {
            printf("[%d, %d]\n", arr1[i], arr2[j]);
        }
    }
    return 0;
}

