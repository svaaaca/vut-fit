#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    int *data;
    int size;
} vector_t;

int vector_constructor(vector_t *v, unsigned int size)
{
    if(v == NULL || size == 0)
        return 0;

    v -> data = malloc(sizeof(int) *size);
    if(v -> data == NULL)
        return 0;

    v -> size = size;

    return 1;
}

void vector_init(vector_t *v)
{
    for(int i = 0; i < v -> size; i++)
        v -> data[i] = 0;
}

void vector_add(vector_t *v, int value)
{
    for(int i = 0; i < v -> size; i++)
        v -> data[i] += value;
}

void vector_destructor(vector_t *v)
{
    if(v == NULL || v -> data == NULL)
        return;

    free(v -> data);
}

int main()
{
    vector_t a;
    if(!(vector_constructor(&a, 10)))
        return 1;

    vector_init(&a);
    vector_add(&a, 7);
    vector_destructor(&a);

    return 0;
}

