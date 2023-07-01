#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("Enter the first number: ");
    int a;
    scanf("%d", &a);

    printf("Enter the second number: ");
    int b;
    scanf("%d", &b);

    printf("Enter the third number: ");
    int c;
    scanf("%d", &c);

    if (a < b && a < c)
        printf("The first number is the smallest.\n");

    else if (c < a && c < b)
        printf("The third number is the smallest.\n");

    else if (b < a && b < c)
        printf("The second number is the smallest.\n");

    return 0;
}

