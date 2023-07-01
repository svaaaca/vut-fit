/*
 * Tabuľka s rozptýlenými položkami
 *
 * S využitím dátových typov zo súboru hashtable.h a pripravených kostier
 * funkcií implementujte tabuľku s rozptýlenými položkami s explicitne
 * zreťazenými synonymami.
 *
 * Pri implementácii uvažujte veľkosť tabuľky HT_SIZE.
 */

#include "hashtable.h"
#include <stdlib.h>
#include <string.h>

int HT_SIZE = MAX_HT_SIZE;

/*
 * Rozptyľovacia funkcia ktorá pridelí zadanému kľúču index z intervalu
 * <0,HT_SIZE-1>. Ideálna rozptyľovacia funkcia by mala rozprestrieť kľúče
 * rovnomerne po všetkých indexoch. Zamyslite sa nad kvalitou zvolenej funkcie.
 */
int get_hash(char *key) {
  int result = 1;
  int length = strlen(key);
  for (int i = 0; i < length; i++) {
    result += key[i];
  }
  return (result % HT_SIZE);
}

/*
 * Inicializácia tabuľky — zavolá sa pred prvým použitím tabuľky.
 */
void ht_init(ht_table_t *table) {
  // Prvotní inicializace položek v tabulce.
  for(int i = 0; i < HT_SIZE; i++) {
    (*table)[i] = NULL;
  }
}

/*
 * Vyhľadanie prvku v tabuľke.
 *
 * V prípade úspechu vráti ukazovateľ na nájdený prvok; v opačnom prípade vráti
 * hodnotu NULL.
 */
ht_item_t *ht_search(ht_table_t *table, char *key) {
  // Nejprve ošetříme stav, pokud by byla hodnota table NULL.
  // Jinak získáme položku podle zadaného klíče pomocí funkce get_hash().
  // Následně procházíme tabulku, dokud nenarazíme na stejný klíč,
  // vrátíme ukazatel na tuto položku, jinak vrátíme NULL.
  if(table == NULL) {
    return NULL;
  }
  else {
    ht_item_t *search_item = (*table)[get_hash(key)];
    while(search_item != NULL) {
      if(strcmp(search_item->key, key) == 0) {
        return search_item;
      }
      search_item = search_item->next;
    }
    return NULL;
  }
}

/*
 * Vloženie nového prvku do tabuľky.
 *
 * Pokiaľ prvok s daným kľúčom už v tabuľke existuje, nahraďte jeho hodnotu.
 *
 * Pri implementácii využite funkciu ht_search. Pri vkladaní prvku do zoznamu
 * synonym zvoľte najefektívnejšiu možnosť a vložte prvok na začiatok zoznamu.
 */
void ht_insert(ht_table_t *table, char *key, float value) {
  // Nejprve ošetříme stav, pokud by byla hodnota table NULL.
  // Jinak vyhledáme položku pomocí funkce ht_search() a pomocí podmínky,
  // jestli je daná položka NULL či nikoliv, rozdělíme řešení na dvě možnosti.
  // Pokud položka v tabulce nebyla, musíme alokovat místo pro novou položku
  // operací malloc(), kterou ošetříme, následně nastavíme klíč nové položky,
  // ukazatel na další položku (může být NULL), položku vložíme na začátek
  // a vložíme daná data, v opačném případě pouze vložíme data.
  if(table == NULL) {
    return;
  }
  else {
    ht_item_t *temporary_item = ht_search(table, key);
    if(temporary_item == NULL) {
      ht_item_t *insert_item = (ht_item_t *) malloc(sizeof(struct ht_item));
      if(insert_item == NULL) {
        return;
      }
      insert_item->key = key;
      insert_item->next = (*table)[get_hash(key)];
      (*table)[get_hash(key)] = insert_item;
      insert_item->value = value;
    }
    else {
      temporary_item->value = value;
    }
  }
}

/*
 * Získanie hodnoty z tabuľky.
 *
 * V prípade úspechu vráti funkcia ukazovateľ na hodnotu prvku, v opačnom
 * prípade hodnotu NULL.
 *
 * Pri implementácii využite funkciu ht_search.
 */
float *ht_get(ht_table_t *table, char *key) {
  // Nejprve ošetříme stav, pokud by byla hodnota table NULL.
  // Pokud hledaná položka neexistuje, návratová hodnota bude NULL,
  // v opačném případě se bude vracet ukazatel na hodnotu hledané položky.
  if(table == NULL) {
    return NULL;
  }
  else {
    ht_item_t *get_item = ht_search(table, key);
    if(get_item == NULL) {
      return NULL;
    }
    else {
      return (&(get_item->value));
    }
  }
}

/*
 * Zmazanie prvku z tabuľky.
 *
 * Funkcia korektne uvoľní všetky alokované zdroje priradené k danému prvku.
 * Pokiaľ prvok neexistuje, nerobte nič.
 *
 * Pri implementácii NEVYUŽÍVAJTE funkciu ht_search.
 */
void ht_delete(ht_table_t *table, char *key) {
  // Nejprve ošetříme stav, pokud by byla hodnota table NULL.
  // Pokud se odstraňovaná položka v tabulce nenachází, nic se neděje.
  // Jinak se provádí cyklus, dokud se nenajde hledaná položka a rozhoduje se,
  // jestli se daná položka nachází na začátku (v tom případě bude novou první
  // položkou momentálně druhá), nebo dále (v ten moment bude dočasná položka
  // ukazovat na momentálně následující položku), a následně se uvolní paměť.
  if(table == NULL) {
    return;
  }
  else {
    ht_item_t *delete_item = (*table)[get_hash(key)];
    ht_item_t *temporary_item = NULL;
    if(delete_item == NULL) {
      return;
    }
    else {
      while(delete_item != NULL) {
        if(strcmp(delete_item->key, key) == 0) {
          if(delete_item == (*table)[get_hash(key)]) {
            (*table)[get_hash(key)] = delete_item->next;
          }
          else {
            temporary_item->next = delete_item->next;
          }
          free(delete_item);
          return;
        }
        temporary_item = delete_item;
        delete_item = delete_item->next;
      }
    }
  }
}

/*
 * Zmazanie všetkých prvkov z tabuľky.
 *
 * Funkcia korektne uvoľní všetky alokované zdroje a uvedie tabuľku do stavu po
 * inicializácii.
 */
void ht_delete_all(ht_table_t *table) {
  // Nejprve ošetříme stav, pokud by byla hodnota table NULL.
  // Následně procházíme tabulku a odstraňujeme položku po položce tak,
  // že si ukazatel na následují položku uložíme do dočasné proměnné,
  // uvolníme paměť a poté využijeme dočasnou proměnnou pro následující
  // položku, tím se dostaneme až na konec cyklu a vše nastavíme na NULL.
  if(table == NULL) {
    return;
  }
  else {
    ht_item_t *delete_item;
    ht_item_t *temporary_item;
    for(int i = 0; i < HT_SIZE; i++) {
      delete_item = (*table)[i];
      while(delete_item != NULL) {
        temporary_item = delete_item->next;
        free(delete_item);
        delete_item = temporary_item;
      }
      (*table)[i] = NULL;
    }
  }
}
