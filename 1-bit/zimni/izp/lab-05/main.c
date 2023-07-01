#include <stdio.h>
#include <stdlib.h>

struct adult_t
{
    int age;
};

int is_adult(struct adult_t a)
{
    if(a.age < 18)
        return 1;
    return 0;
}

int main()
{
    struct adult_t person;
    printf("Enter your age: ");
    scanf("%d", &person.age);

    int i = is_adult(person);
    if(i == 0)
        printf("You are an adult.\n");
    else
    	printf("You are not an adult.\n");

    return 0;
}

