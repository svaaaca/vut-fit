#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    int a;
    int b;
} tuple_t;

int rel_minmax(tuple_t *rel, int rel_size, tuple_t *min, tuple_t *max)
{
    *min = *rel;
    *max = *rel;

    for (int i = 0; i < rel_size; i++)
    {
        for (int j = (i + 1); j < rel_size; j++)
        {
            if (rel[i].a == rel[j].a && rel[i].b != rel[j].b)
                return 0;
        }
        *min = rel[i].b < min -> b ? rel[i] : *min;
        *max = rel[i].b < max -> b ? rel[i] : *max;
    }
    return 1;
}

int main()
{
    tuple_t rel[10];
    for (int i = 0; i < 10; i++)
    {
        rel[i].a = i;
        int num = 2 * i - 1;
        rel[i].b = i % 2 == 0 ? num : -num;
    }

    tuple_t max;
    tuple_t min;

    int tmp = rel_minmax(rel, 10, &min, &max);
    if (tmp == 1)
        printf("Min: [%d, %d], Max: [%d, %d]\n", min.a, min.b, max.a, max.b);
    else
        printf("Not a function\n");
    return 0;
}

