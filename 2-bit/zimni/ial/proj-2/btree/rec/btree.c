/*
 * Binárny vyhľadávací strom — rekurzívna varianta
 *
 * S využitím dátových typov zo súboru btree.h a pripravených kostier funkcií
 * implementujte binárny vyhľadávací strom pomocou rekurzie.
 */

#include "../btree.h"
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
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
bool bst_search(bst_node_t *tree, char key, int *value) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL (vracíme false).
  // Pokud se hledaný klíč shoduje s kořenovým klíčem, uložíme hodnotu a vrátíme true.
  // Jestli je klíč menší, voláme rekurzivně funkci pro levý podstrom,
  // v opačném případě pro pravý podstrom.
  if(tree == NULL) {
    return false;
  }
  else {
    if(tree->key == key) {
      *value = tree->value;
      return true;
    }
    else if(tree->key > key) {
      return bst_search(tree->left, key, value);
    }
    else if(tree->key < key) {
      return bst_search(tree->right, key, value);
    }
    else {
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
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_insert(bst_node_t **tree, char key, int value) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL.
  // Pokud ano, alokujeme paměť pro nový uzel, jestliže alokace neselže, do uzlu
  // vložíme klíč, hodnotu a levý a pravý potomek nastavíme na NULL.
  // V případě, že kořenový uzel není NULL, hledáme takový uzel, který má
  // stejný klíč, jako je klíč hledaný, pokud se rovnají, našli jsem uzel,
  // jinak voláme rekurzivně tuto funkci buď pro levý nebo pravý podstrom.
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
    }
    else if((*tree)->key > key) {
      bst_insert(&((*tree)->left), key, value);
    }
    else if((*tree)->key < key) {
      bst_insert(&((*tree)->right), key, value);
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
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_replace_by_rightmost(bst_node_t *target, bst_node_t **tree) {
  // Nejdříve ověříme, zda není kořenový uzel stromu NULL (i přes předpoklad).
  // Jestli je pravý podstrom kořenového uzlu NULL, nastavíme klíč a hodnotu
  // cílového uzlu hodnotami z kořenového uzlu, pokud neměl kořenový uzel
  // levý podstrom, můžeme uvolnit jím používanou paměť a nastavit ukazatel
  // na NULL, v opačném případě se na jeho místo dostává jeho levý potomek.
  // Jestliže měl pravý podstrom, volá se funkce bst_replace_by_rightmost().
  if(*tree == NULL) {
    return;
  }
  else {
    if((*tree)->right == NULL) {
      target->key = (*tree)->key;
      target->value = (*tree)->value;
      if((*tree)->left == NULL) {
        free(*tree);
        *tree = NULL;
      }
      else {
        bst_node_t *temporary = *tree;
        *tree = (*tree)->left;
        free(temporary);
        temporary = NULL;
      }
    }
    else {
      bst_replace_by_rightmost(target, &((*tree)->right));
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
 * Funkciu implementujte rekurzívne pomocou bst_replace_by_rightmost a bez
 * použitia vlastných pomocných funkcií.
 */
void bst_delete(bst_node_t **tree, char key) {
  // Jestliže kořenový uzel není NULL, rozdělíme řešení na tři situace.
  // Pokud je hledaný klíč menší, voláme funkci rekurzivně pro levý podstrom,
  // je-li větší, voláme funkci rekurzivně naopak pro pravý podstrom.
  // Ovšem pokud se klíče rovnají, našli jsme hledaný uzel k odstranění.
  // Když nemá žádné podstromy, jednoduše uvolníme paměť a nastavíme ukazatel,
  // jestliže má oba podstromy, voláme pomocnou funkci bst_replace_by_rightmost(),
  // nakonec, pokud má pouze pravý podstrom, tak ho jím nahradíme, má-li pouze
  // levý podstrom, tak ho jím nahradíme a uvolníme používanou paměť.
  if(*tree == NULL) {
    return;
  }
  else {
    if((*tree)->key > key) {
      bst_delete(&((*tree)->left), key);
    }
    else if((*tree)->key < key) {
      bst_delete(&((*tree)->right), key);
    }
    else {
      if(((*tree)->left == NULL) && ((*tree)->right == NULL)) {
        free(*tree);
        *tree = NULL;
      }
      else if(((*tree)->left != NULL) && ((*tree)->right != NULL)) {
        bst_replace_by_rightmost(*tree, &((*tree)->left));
      }
      else {
        bst_node_t *temporary = *tree;
        if(((*tree)->left == NULL) && ((*tree)->right != NULL)) {
          *tree = (*tree)->right;
          free(temporary);
          temporary = NULL;
        }
        else if(((*tree)->left != NULL) && ((*tree)->right == NULL)) {
          *tree = (*tree)->left;
          free(temporary);
          temporary = NULL;
        }
      }
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
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_dispose(bst_node_t **tree) {
  // Pokud je kořenový uzel NULL, stav je jako po inicializaci.
  // Jinak zavoláme rekurzivně funkci jak pro levý, tak pro pravý podstrom
  // a následně uvolníme používanou paměť.
  if(*tree == NULL) {
    return;
  }
  else {
    bst_dispose(&((*tree)->left));
    bst_dispose(&((*tree)->right));
    free(*tree);
    *tree = NULL;
  }
}

/*
 * Preorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_preorder(bst_node_t *tree) {
  // Jestliže není kořenový uzel NULL, tak pro Preorder průchod stromem platí,
  // že nejdříve zpracujeme kořenový uzel, poté zpracujeme jeho levý podstrom,
  // a nakonec zpracujeme jeho pravý podstrom.
  if(tree == NULL) {
    return;
  }
  else {
    bst_print_node(tree);
    bst_preorder(tree->left);
    bst_preorder(tree->right);
  }
}

/*
 * Inorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_inorder(bst_node_t *tree) {
  // Jestliže není kořenový uzel NULL, tak pro Inorder průchod stromem platí,
  // že nejdříve zpracujeme levý podstrom, poté zpracujeme kořenový uzel,
  // a nakonec zpracujeme pravý podstrom.
  if(tree == NULL) {
    return;
  }
  else {
    bst_inorder(tree->left);
    bst_print_node(tree);
    bst_inorder(tree->right);
  }
}
/*
 * Postorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_postorder(bst_node_t *tree) {
  // Jestliže není kořenový uzel NULL, tak pro Postorder průchod stromem platí,
  // že nejdříve zpracujeme levý podstrom, poté zpracujeme pravý podstrom,
  // a nakonec zpracujeme kořenový uzel.
  if(tree == NULL) {
    return;
  }
  else {
    bst_postorder(tree->left);
    bst_postorder(tree->right);
    bst_print_node(tree);
  }
}
