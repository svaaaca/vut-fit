/*
 * Binárny vyhľadávací strom — iteratívna varianta
 *
 * S využitím dátových typov zo súboru btree.h, zásobníkov zo súborov stack.h a
 * stack.c a pripravených kostier funkcií implementujte binárny vyhľadávací
 * strom bez použitia rekurzie.
 */

#include "../btree.h"
#include "stack.h"
#include <stdio.h>
#include <stdlib.h>

/*
 * Inicializácia stromu.
 *
 * Užívateľ musí zaistiť, že incializácia sa nebude opakovane volať nad
 * inicializovaným stromom. V opačnom prípade môže dôjsť k úniku pamäte (memory
 * leak). Keďže neinicializovaný ukazovateľ má nedefinovanú hodnotu, nie je
 * možné toto detegovať vo funkcii.
 */
void bst_init(bst_node_t **tree) {
  // Prvotní inicializace stromu.
  *tree = NULL;
}

/*
 * Nájdenie uzlu v strome.
 *
 * V prípade úspechu vráti funkcia hodnotu true a do premennej value zapíše
 * hodnotu daného uzlu. V opačnom prípade funckia vráti hodnotu false a premenná
 * value ostáva nezmenená.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
bool bst_search(bst_node_t *tree, char key, int *value) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL (vracíme false).
  // Pokud se hledaný klíč shoduje s kořenovým klíčem, uložíme hodnotu a vrátíme true.
  // Jinak provádíme cyklus, dokud ukazatel tree není NULL a rozhodujeme se podle
  // hodnoty klíče (pokud se rovná, našli jsme hledaný uzel a vrítíme true, jestli je
  // klíč menší, hledáme vlevo, je-li větší hledáme vpravo). Pokud cyklus skončí -
  // tree je NULL, a nenašli jsme, vracíme false.
  if(tree == NULL){
    return false;
  }
  else {
    if(tree->key == key) {
      *value = tree->value;
      return true;
    }
    else {
      while(tree != NULL) {
        if(tree->key == key) {
          *value = tree->value;
          return true;
        }
        else {
          if(tree->key > key) {
            tree = tree->left;
          }
          else {
            tree = tree->right;
          }
        }
      }
      return false;
    }
  }
}

/*
 * Vloženie uzlu do stromu.
 *
 * Pokiaľ uzol so zadaným kľúčom v strome už existuje, nahraďte jeho hodnotu.
 * Inak vložte nový listový uzol.
 *
 * Výsledný strom musí spĺňať podmienku vyhľadávacieho stromu — ľavý podstrom
 * uzlu obsahuje iba menšie kľúče, pravý väčšie.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
void bst_insert(bst_node_t **tree, char key, int value) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Pokud ano, alokujeme paměť pro nový uzel, jestliže alokace neselže, do uzlu
  // vložíme klíč, hodnotu a levý a pravý potomek nastavíme na NULL.
  // V případě, že kořenový uzel není NULL, hledáme takový uzel, který má
  // stejný klíč, jako je klíč hledaný, pokud nalezneme, upravíme hodnotu.
  // Jinak provádíme cyklus, dokud není *tree NULL, pokud je hledaný klíč menší
  // a zároveň je jeho levý potomek NULL, alokujeme místo pro nový uzel,
  // začleníme ho do stromu a nastavíme hodnotu, klíč, ukazatele a ukončíme
  // cyklus, jinak nastavíme jako další hledaný uzel levý potomek dříve hledaného
  // (to samé pro pravý podstrom, pokud je hledaný klíč větší).
  if(*tree == NULL) {
    *tree = (bst_node_t *) malloc(sizeof(struct bst_node));
    if(tree == NULL) {
      return;
    }
    (*tree)->key = key;
    (*tree)->left = NULL;
    (*tree)->right = NULL;
    (*tree)->value = value;
  }
  else {
    if((*tree)->key == key) {
      (*tree)->value = value;
      return;
    }
    while(*tree != NULL) {
      if((*tree)->key == key) {
        (*tree)->value = value;
        return;
      }
      else if((*tree)->key > key) {
        if((*tree)->left == NULL) {
          bst_node_t *insert = (bst_node_t *) malloc(sizeof(struct bst_node));
          if(insert == NULL) {
            return;
          }
          insert->key = key;
          insert->left = NULL;
          insert->right = NULL;
          insert->value = value;
          (*tree)->left = insert;
          return;
        }
        else {
          tree = &((*tree)->left);
        }
      }
      else {
        if((*tree)->right == NULL) {
          bst_node_t *insert = (bst_node_t *) malloc(sizeof(struct bst_node));
          if(insert == NULL) {
            return;
          }
          insert->key = key;
          insert->left = NULL;
          insert->right = NULL;
          insert->value = value;
          (*tree)->right = insert;
          return;
        }
        else {
          tree = &((*tree)->right);
        }
      }
    }
  }
}

/*
 * Pomocná funkcia ktorá nahradí uzol najpravejším potomkom.
 *
 * Kľúč a hodnota uzlu target budú nahradené kľúčom a hodnotou najpravejšieho
 * uzlu podstromu tree. Najpravejší potomok bude odstránený. Funkcia korektne
 * uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkcia predpokladá že hodnota tree nie je NULL.
 *
 * Táto pomocná funkcia bude využitá pri implementácii funkcie bst_delete.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
void bst_replace_by_rightmost(bst_node_t *target, bst_node_t **tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL (i přes předpoklad).
  // Následuje cyklus, dokud není pravý potomek aktuálního uzlu NULL, přičemž
  // si uchováváme ukazatel otce a pokud je to možné, jdeme v rámci stromu
  // doprava, jsme-li na konci, vložíme do cílového uzlu klíč a hodnotu,
  // pokud neměl mazaný uzel levého potomka, jeho otec nebude mít pravého,
  // jinak bude nastaven jako pravý potomek otce levý potomek odstraněného.
  if(*tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = *tree;
    bst_node_t *father = *tree;
    while(temporary->right != NULL) {
      father = temporary;
      temporary = temporary->right;
    }
    target->key = temporary->key;
    target->value = temporary->value;
    if(temporary->left == NULL) {
      father->right = NULL;
      free(temporary);
      return;
    }
    else {
      father->right = temporary->left;
      free(temporary);
      return;
    }
  }
}

/*
 * Odstránenie uzlu v strome.
 *
 * Pokiaľ uzol so zadaným kľúčom neexistuje, funkcia nič nerobí.
 * Pokiaľ má odstránený uzol jeden podstrom, zdedí ho otec odstráneného uzla.
 * Pokiaľ má odstránený uzol oba podstromy, je nahradený najpravejším uzlom
 * ľavého podstromu. Najpravejší uzol nemusí byť listom!
 * Funkcia korektne uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkciu implementujte iteratívne pomocou bst_replace_by_rightmost a bez
 * použitia vlastných pomocných funkcií.
 */
void bst_delete(bst_node_t **tree, char key) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Následuje cyklus, který nalezne uzel, jenž mýá být smazán, zároveň se
  // v rámci cyklu uchovává ukazatel otce, když cyklus neuspěje s nalezením
  // hledaného uzlu, nic se neděje, jinak budeme odstraňovat daný uzel.
  // Pokud byl uzel bez potomků, jeho otec mít potomka také nebude.
  // Jestliže měl uzel jednoho potomka, tak ho jeho otec zdědí, a nakonec,
  // jestli měl oba potomky, je volána funkce bst_replace_by_rightmost()
  // nad jeho levým podstromem.
  if(*tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = *tree;
    bst_node_t *father = *tree;
    if((*tree)->key == key) {
      if(((*tree)->left == NULL) && ((*tree)->right == NULL)) {
        free(*tree);
        *tree = NULL;
        return;
      }
      else if(((*tree)->left == NULL) && ((*tree)->right != NULL)) {
        *tree = (*tree)->right;
        free(temporary);
        temporary = NULL;
        return;
      }
      else if(((*tree)->left != NULL) && ((*tree)->right == NULL)) {
        *tree = (*tree)->left;
        free(temporary);
        temporary = NULL;
        return;
      }
    }
    while(temporary->key != key) {
      father = temporary;
      if(temporary->key > key) {
        if(temporary->left == NULL) {
          return;
        }
        else {
          temporary = temporary->left;
        }
      }
      else {
        if(temporary->key < key) {
          if(temporary->right == NULL) {
            return;
          }
          else {
            temporary = temporary->right;
          }
        }
      }
    }
    if((temporary->left == NULL) && (temporary->right == NULL)) {
      if(father->left == temporary) {
        father->left = NULL;
        free(temporary);
        return;
      }
      else {
        father->right = NULL;
        free(temporary);
        return;
      }
    }
    else if((temporary->left == NULL) && (temporary->right != NULL)) {
      if(father->left == temporary) {
        father->left = temporary->right;
        free(temporary);
        return;
      }
      else {
        father->right = temporary->right;
        free(temporary);
        return;
      }
    }
    else if((temporary->left != NULL) && (temporary->right == NULL)) {
      if(father->left == temporary) {
        father->left = temporary->left;
        free(temporary);
        return;
      }
      else {
        father->right = temporary->left;
        free(temporary);
        return;
      }
    }
    else if((temporary->left != NULL) && (temporary->right != NULL)) {
      bst_replace_by_rightmost(temporary, &(temporary->left));
      return;
    }
  }
}

/*
 * Zrušenie celého stromu.
 *
 * Po zrušení sa celý strom bude nachádzať v rovnakom stave ako po
 * inicializácii. Funkcia korektne uvoľní všetky alokované zdroje rušených
 * uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_dispose(bst_node_t **tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Poté inicializujeme zásobník pro uzly pomocí alokace paměti a následuje
  // cyklus, dokud není celý strom i zásobník zcela prázdný, pokud je strom
  // prázdný, ale zásobník nikoliv, získáme uzel z vrcholu zásobníku a popneme
  // ho, následně probíhá další iterace, je-li naopak strom neprázdný, pushneme
  // na zásobník potomek, který není NULL, podle toho nastavíme další uzel
  // a aktuálně zpracovaný uvolníme, nakonec uvolníme zásobník a nastavíme
  // ukazatel na strom, jako by byl právě po inicializaci.
  if(*tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = *tree;
    bst_node_t *delete = NULL;
    stack_bst_t *node = (stack_bst_t *) malloc(sizeof(stack_bst_t));
    if(node == NULL) {
      return;
    }
    stack_bst_init(node);
    while(true) {
      if(temporary == NULL) {
        if(stack_bst_empty(node) == true) {
          break;
        }
        else {
          temporary = stack_bst_top(node);
          stack_bst_pop(node);
        }
      }
      else {
        if(temporary->left != NULL) {
          stack_bst_push(node, temporary->left);
        }
        else if(temporary->right != NULL) {
          stack_bst_push(node, temporary->right);
        }
        delete = temporary;
        (temporary->left != NULL) ? (temporary = temporary->right) : (temporary = temporary->left);
        free(delete);
      }
    }
    free(node);
    *tree = NULL;
  }
}

/*
 * Pomocná funkcia pre iteratívny preorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu.
 * Nad spracovanými uzlami zavola bst_print_node a uloží ich do zásobníku uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_preorder(bst_node_t *tree, stack_bst_t *to_visit) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Jinak cyklus prochází uzly až k tomu nejlevějšímu, volá nad nimi
  // funkci bst_print_node() a ukládá je na zásobník.
  if(tree == NULL) {
    return;
  }
  else {
    while(tree != NULL) {
      bst_print_node(tree);
      stack_bst_push(to_visit, tree);
      tree = tree->left;
    }
  }
}

/*
 * Preorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_preorder a
 * zásobníku uzlov bez použitia vlastných pomocných funkcií.
 */
void bst_preorder(bst_node_t *tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Inicializujeme zásobník, pomocí funkce bst_leftmost_preorder() se dostaneme
  // na nejlevější uzel, přičemž zpracovávané uzly jsou tisknuty, poté následuje
  // cyklus do té doby, než není zásobník prázdný a vždy si z jeho vrcholu
  // nahrajeme uzel, pro který znovu zavoláme bst_leftmost_preorder().
  if(tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = NULL;
    stack_bst_t *node = (stack_bst_t *) malloc(sizeof(stack_bst_t));
    if(node == NULL) {
      return;
    }
    stack_bst_init(node);
    bst_leftmost_preorder(tree, node);
    while(stack_bst_empty(node) == false) {
      temporary = stack_bst_top(node);
      stack_bst_pop(node);
      bst_leftmost_preorder(temporary->right, node);
    }
    free(node);
  }
}

/*
 * Pomocná funkcia pre iteratívny inorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu a ukladá uzly do
 * zásobníku uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_inorder(bst_node_t *tree, stack_bst_t *to_visit) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Jinak cyklus prochází uzly až k tomu nejlevějšímu a vkládá je na zásobník.
  if(tree == NULL) {
    return;
  }
  else {
    while(tree != NULL) {
      stack_bst_push(to_visit, tree);
      tree = tree->left;
    }
  }
}

/*
 * Inorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_inorder a
 * zásobníku uzlov bez použitia vlastných pomocných funkcií.
 */
void bst_inorder(bst_node_t *tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Inicializujeme zásobník, pomocí funkce bst_leftmost_inorder() se dostaneme
  // na nejlevější uzel, poté následuje cyklus do té doby, než není zásobník prázdný
  // a vždy si z jeho vrcholu nahrajeme uzel, pro který voláme bst_print_node()
  // a nakonec znovu zavoláme bst_leftmost_inorder().
  if(tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = NULL;
    stack_bst_t *node = (stack_bst_t *) malloc(sizeof(stack_bst_t));
    if(node == NULL) {
      return;
    }
    stack_bst_init(node);
    bst_leftmost_inorder(tree, node);
    while(stack_bst_empty(node) == false) {
      temporary = stack_bst_top(node);
      stack_bst_pop(node);
      bst_print_node(temporary);
      bst_leftmost_inorder(temporary->right, node);
    }
    free(node);
  }
}

/*
 * Pomocná funkcia pre iteratívny postorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu a ukladá uzly do
 * zásobníku uzlov. Do zásobníku bool hodnôt ukladá informáciu že uzol
 * bol navštívený prvý krát.
 *
 * Funkciu implementujte iteratívne pomocou zásobníkov uzlov a bool hodnôt a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_postorder(bst_node_t *tree, stack_bst_t *to_visit,
                            stack_bool_t *first_visit) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Jinak cyklus prochází uzly až k tomu nejlevějšímu, vkládá je na zásobník
  // a ukládá pravdivostní hodnotu první návštěvy daného uzlu.
  if(tree == NULL) {
    return;
  }
  else {
    while(tree != NULL) {
      stack_bst_push(to_visit, tree);
      stack_bool_push(first_visit, true);
      tree = tree->left;
    }
  }
}

/*
 * Postorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_postorder a
 * zásobníkov uzlov a bool hodnôt bez použitia vlastných pomocných funkcií.
 */
void bst_postorder(bst_node_t *tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Inicializujeme zásobníky, pomocí funkce bst_leftmost_postorder() se dostaneme
  // na nejlevější uzel a následuje cyklus, dokud není zásobník s uzly prázdný.
  // Vždy si nahrajeme uzel ze zásobníku a podle pravdivostní hodnoty z druhého
  // zásobníku se rozhodujeme - pokud je pravdivostní hodnota false (je to druhá
  // návštěva), zpracujeme uzel a odstraníme ho ze zásobníku, je-li ale hodnota
  // true (jedná se o první návštěvu), nahrajeme hodnotu false na zásobník a voláme
  // funkci bst_leftmost_postorder().
  if(tree == NULL) {
    return;
  }
  else {
    bst_node_t *temporary = NULL;
    bool first_visit;
    stack_bst_t *node = (stack_bst_t *) malloc(sizeof(stack_bst_t));
    if(node == NULL) {
      return;
    }
    stack_bool_t *visit = (stack_bool_t *) malloc(sizeof(stack_bool_t));
    if(visit == NULL) {
      return;
    }
    stack_bst_init(node);
    stack_bool_init(visit);
    bst_leftmost_postorder(tree, node, visit);
    while(stack_bst_empty(node) == false) {
      temporary = stack_bst_top(node);
      first_visit = stack_bool_top(visit);
      stack_bool_pop(visit);
      if(first_visit == false) {
        bst_print_node(temporary);
        stack_bst_pop(node);
      }
      else {
        stack_bool_push(visit, false);
        bst_leftmost_postorder(temporary->right, node, visit);
      }
    }
    free(node);
    free(visit);
  }
}
