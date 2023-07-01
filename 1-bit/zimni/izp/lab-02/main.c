#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
    int arr[5];
    printf("Enter five array numbers: \n");
    for(int i = 0; i < 5; i++){
        scanf("%d", &arr[i]);
    }
    double sum = arr[0] + arr[1] + arr[2] + arr[3] + arr[4];
    double mean = sum / 5;

    printf("Arithmetic mean: %g\n", mean);

    return 0;
}

