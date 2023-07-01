#include "sll.h"
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>


List list_ctor()
{
    List list;
    list.first = NULL;
    return list;
}

Item *item_ctor(Object data)
{
    Item *item;
    item = malloc(sizeof(Item));
    item->data = data;
    item->next = NULL;
    return item;
}


void list_insert_first(List *list, Item *i)
{
    i->next = list->first;
    list->first = i;
}


bool list_empty(List *list)
{
    if(list->first == NULL)
        return true;
    else
        return false;
}

void list_delete_first(List *list)
{
    Item *tmp = list->first->next;
    list->first = tmp;
    free(list->first);
}

unsigned list_count(List *list)
{
    int count = 0;
    Item *tmp = list->first;
    while(tmp != NULL)
    {
        count++;
        tmp = tmp->next;
    }
    return count;
}

void list_dtor(List *list)
{
    while(list->first != NULL)
        list_delete_first(list);
}

