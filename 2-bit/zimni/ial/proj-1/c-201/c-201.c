/* c201.c **********************************************************************
** Téma: Jednosměrný lineární seznam
**
**                     Návrh a referenční implementace: Petr Přikryl, říjen 1994
**                                          Úpravy: Andrea Němcová listopad 1996
**                                                   Petr Přikryl, listopad 1997
**                                Přepracované zadání: Petr Přikryl, březen 1998
**                                  Přepis do jazyka C: Martin Tuček, říjen 2004
**                                              Úpravy: Kamil Jeřábek, září 2020
**                                                    Daniel Dolejška, září 2021
**                                                    Daniel Dolejška, září 2022
**
** Implementujte abstraktní datový typ jednosměrný lineární seznam.
** Užitečným obsahem prvku seznamu je celé číslo typu int.
** Seznam bude jako datová abstrakce reprezentován proměnnou typu List.
** Definici konstant a typů naleznete v hlavičkovém souboru c201.h.
**
** Vaším úkolem je implementovat následující operace, které spolu s výše
** uvedenou datovou částí abstrakce tvoří abstraktní datový typ List:
**
**      List_Dispose ....... zrušení všech prvků seznamu,
**      List_Init .......... inicializace seznamu před prvním použitím,
**      List_InsertFirst ... vložení prvku na začátek seznamu,
**      List_First ......... nastavení aktivity na první prvek,
**      List_GetFirst ...... vrací hodnotu prvního prvku,
**      List_DeleteFirst ... zruší první prvek seznamu,
**      List_DeleteAfter ... ruší prvek za aktivním prvkem,
**      List_InsertAfter ... vloží nový prvek za aktivní prvek seznamu,
**      List_GetValue ...... vrací hodnotu aktivního prvku,
**      List_SetValue ...... přepíše obsah aktivního prvku novou hodnotou,
**      List_Next .......... posune aktivitu na další prvek seznamu,
**      List_IsActive ...... zjišťuje aktivitu seznamu.
**
** Při implementaci funkcí nevolejte žádnou z funkcí implementovaných v rámci
** tohoto příkladu, není-li u dané funkce explicitně uvedeno něco jiného.
**
** Nemusíte ošetřovat situaci, kdy místo legálního ukazatele na seznam předá
** někdo jako parametr hodnotu NULL.
**
** Svou implementaci vhodně komentujte!
**
** Terminologická poznámka: Jazyk C nepoužívá pojem procedura.
** Proto zde používáme pojem funkce i pro operace, které by byly
** v algoritmickém jazyce Pascalovského typu implemenovány jako procedury
** (v jazyce C procedurám odpovídají funkce vracející typ void).
**
**/

#include "c201.h"

#include <stdio.h> // printf
#include <stdlib.h> // malloc, free

int error_flag;
int solved;

/**
 * Vytiskne upozornění na to, že došlo k chybě. Nastaví error_flag na logickou 1.
 * Tato funkce bude volána z některých dále implementovaných operací.
 */
void List_Error() {
	printf("*ERROR* The program has performed an illegal operation.\n");
	error_flag = TRUE;
}

/**
 * Provede inicializaci seznamu list před jeho prvním použitím (tzn. žádná
 * z následujících funkcí nebude volána nad neinicializovaným seznamem).
 * Tato inicializace se nikdy nebude provádět nad již inicializovaným
 * seznamem, a proto tuto možnost neošetřujte. Vždy předpokládejte,
 * že neinicializované proměnné mají nedefinovanou hodnotu.
 *
 * @param list Ukazatel na strukturu jednosměrně vázaného seznamu
 */
void List_Init( List *list ) {
	// Inicializace prázdného seznamu
	list->firstElement = NULL;
	list->activeElement = NULL;
}

/**
 * Zruší všechny prvky seznamu list a uvede seznam list do stavu, v jakém se nacházel
 * po inicializaci. Veškerá paměť používaná prvky seznamu list bude korektně
 * uvolněna voláním operace free.
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 **/
void List_Dispose( List *list ) {
	// Seznam se stává neaktivním a poté se provádí cyklus, dokud nebude prázdný první prvek
	// Do dočasného prvku se vloží prvek následující a vymaže se prvek aktuálně první
	// Jako první prvek se nově nastaví aktuálně prvek následující a cyklus se opakuje
	list->activeElement = NULL;
	while(list->firstElement != NULL) {
		ListElementPtr temporaryElement;
		temporaryElement = list->firstElement->nextElement;
		free(list->firstElement);
		list->firstElement = temporaryElement;
	}
}

/**
 * Vloží prvek s hodnotou data na začátek seznamu list.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci List_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 * @param data Hodnota k vložení na začátek seznamu
 */
void List_InsertFirst( List *list, int data ) {
	// Alokace místa pro nový prvek pomocí operace malloc a její ošetření
	// Přiřazení hodnoty data novému prvku a zařazení nového prvku na začátek seznamu
	ListElementPtr newElement = (ListElementPtr) malloc(sizeof(struct ListElement));
	if(newElement == NULL) {
		List_Error();
	}
	else {
		newElement->data = data;
		newElement->nextElement = list->firstElement;
		list->firstElement = newElement;
	}
}

/**
 * Nastaví aktivitu seznamu list na jeho první prvek.
 * Funkci implementujte jako jediný příkaz, aniž byste testovali,
 * zda je seznam list prázdný.
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 */
void List_First( List *list ) {
	// Aktivním prvkem se stává první prvek seznamu
	list->activeElement = list->firstElement;
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu prvního prvku seznamu list.
 * Pokud je seznam list prázdný, volá funkci List_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void List_GetFirst( List *list, int *dataPtr ) {
	// Ošetření stavu voláním funkce List_Error(), pokud je seznam prázdný
	// Do proměnné dataPtr se uloží hodnota prvního prvku seznamu
	if(list->firstElement == NULL) {
		List_Error();
	}
	else {
		*dataPtr = list->firstElement->data;
	}
}

/**
 * Zruší první prvek seznamu list a uvolní jím používanou paměť.
 * Pokud byl rušený prvek aktivní, aktivita seznamu se ztrácí.
 * Pokud byl seznam list prázdný, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 */
void List_DeleteFirst( List *list ) {
	// Je-li první prvek zároveň prvkem aktivním, stane se seznam neaktivním
	// Do dočasného prvku se vloží druhý prvek a uvolní se paměť prvního prvku
	// Nakonec se jako první prvek stanoví dříve inicializovaný dočasný prvek
	if(list->firstElement != NULL) {
		if(list->firstElement == list->activeElement) {
			list->activeElement = NULL;
		}
		ListElementPtr temporaryElement;
		temporaryElement = list->firstElement->nextElement;
		free(list->firstElement);
		list->firstElement = temporaryElement;
	}
}

/**
 * Zruší prvek seznamu list za aktivním prvkem a uvolní jím používanou paměť.
 * Pokud není seznam list aktivní nebo pokud je aktivní poslední prvek seznamu list,
 * nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 */
void List_DeleteAfter( List *list ) {
	// Ověření, jestli je seznam aktivní (nikoliv poslední prvek)
	// Pomocí dočasného prvku se odstraní prvek za aktuálně aktivním
	// Následně se uvolní paměť po odstraněném prvku
	ListElementPtr temporaryElement;
	if(list->activeElement != NULL) {
		if(list->activeElement->nextElement != NULL) {
			temporaryElement = list->activeElement->nextElement;
			list->activeElement->nextElement = temporaryElement->nextElement;
			free(temporaryElement);
		}
	}
}

/**
 * Vloží prvek s hodnotou data za aktivní prvek seznamu list.
 * Pokud nebyl seznam list aktivní, nic se neděje!
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * zavolá funkci List_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 * @param data Hodnota k vložení do seznamu za právě aktivní prvek
 */
void List_InsertAfter( List *list, int data ) {
	// Pokud je seznam aktivní, alokuje se místo pro nový prvek
	// Zkontroluje se, zda se operace malloc provedla v pořádku
	// Do nového prvku se uloží hodnota data a prvek se zařadí do seznamu
	if(list->activeElement != NULL) {
		ListElementPtr newElement = (ListElementPtr) malloc(sizeof(struct ListElement));
		if(newElement == NULL) {
			List_Error();
		}
		else {
			newElement->data = data;
			newElement->nextElement = list->activeElement->nextElement;
			list->activeElement->nextElement = newElement;
		}
	}
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu aktivního prvku seznamu list.
 * Pokud seznam není aktivní, zavolá funkci List_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void List_GetValue( List *list, int *dataPtr ) {
	// Ošetření stavu voláním funkce List_Error(), pokud je seznam prázdný
	// Do proměnné dataPtr se uloží hodnota aktivního prvku seznamu
	if(list->activeElement == NULL) {
		List_Error();
	}
	else {
		*dataPtr = list->activeElement->data;
	}
}

/**
 * Přepíše data aktivního prvku seznamu list hodnotou data.
 * Pokud seznam list není aktivní, nedělá nic!
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 * @param data Nová hodnota právě aktivního prvku
 */
void List_SetValue( List *list, int data ) {
	// Je-li seznam aktivní, uloží se hodnota data do aktivního prvku
	if(list->activeElement != NULL) {
		list->activeElement->data = data;
	}
}

/**
 * Posune aktivitu na následující prvek seznamu list.
 * Všimněte si, že touto operací se může aktivní seznam stát neaktivním.
 * Pokud není předaný seznam list aktivní, nedělá funkce nic.
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 */
void List_Next( List *list ) {
	// Je-li seznam aktivní, stává se novým aktivním prvkem prvek následující
	if(list->activeElement != NULL) {
		list->activeElement = list->activeElement->nextElement;
	}
}

/**
 * Je-li seznam list aktivní, vrací nenulovou hodnotu, jinak vrací 0.
 * Tuto funkci je vhodné implementovat jedním příkazem return.
 *
 * @param list Ukazatel na inicializovanou strukturu jednosměrně vázaného seznamu
 */
int List_IsActive( List *list ) {
	// Pokud je seznam aktivní, podmínka se vyhodnotí jako TRUE, jinak FALSE
	return (list->activeElement != NULL);
}

/* Konec c201.c */
