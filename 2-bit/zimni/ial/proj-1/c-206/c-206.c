/* ******************************* c206.c *********************************** */
/*  Předmět: Algoritmy (IAL) - FIT VUT v Brně                                 */
/*  Úkol: c206 - Dvousměrně vázaný lineární seznam                            */
/*  Návrh a referenční implementace: Bohuslav Křena, říjen 2001               */
/*  Vytvořil: Martin Tuček, říjen 2004                                        */
/*  Upravil: Kamil Jeřábek, září 2020                                         */
/*           Daniel Dolejška, září 2021                                       */
/*           Daniel Dolejška, září 2022                                       */
/* ************************************************************************** */
/*
** Implementujte abstraktní datový typ dvousměrně vázaný lineární seznam.
** Užitečným obsahem prvku seznamu je hodnota typu int. Seznam bude jako datová
** abstrakce reprezentován proměnnou typu DLList (DL znamená Doubly-Linked
** a slouží pro odlišení jmen konstant, typů a funkcí od jmen u jednosměrně
** vázaného lineárního seznamu). Definici konstant a typů naleznete
** v hlavičkovém souboru c206.h.
**
** Vaším úkolem je implementovat následující operace, které spolu s výše
** uvedenou datovou částí abstrakce tvoří abstraktní datový typ obousměrně
** vázaný lineární seznam:
**
**      DLL_Init ........... inicializace seznamu před prvním použitím,
**      DLL_Dispose ........ zrušení všech prvků seznamu,
**      DLL_InsertFirst .... vložení prvku na začátek seznamu,
**      DLL_InsertLast ..... vložení prvku na konec seznamu,
**      DLL_First .......... nastavení aktivity na první prvek,
**      DLL_Last ........... nastavení aktivity na poslední prvek,
**      DLL_GetFirst ....... vrací hodnotu prvního prvku,
**      DLL_GetLast ........ vrací hodnotu posledního prvku,
**      DLL_DeleteFirst .... zruší první prvek seznamu,
**      DLL_DeleteLast ..... zruší poslední prvek seznamu,
**      DLL_DeleteAfter .... ruší prvek za aktivním prvkem,
**      DLL_DeleteBefore ... ruší prvek před aktivním prvkem,
**      DLL_InsertAfter .... vloží nový prvek za aktivní prvek seznamu,
**      DLL_InsertBefore ... vloží nový prvek před aktivní prvek seznamu,
**      DLL_GetValue ....... vrací hodnotu aktivního prvku,
**      DLL_SetValue ....... přepíše obsah aktivního prvku novou hodnotou,
**      DLL_Previous ....... posune aktivitu na předchozí prvek seznamu,
**      DLL_Next ........... posune aktivitu na další prvek seznamu,
**      DLL_IsActive ....... zjišťuje aktivitu seznamu.
**
** Při implementaci jednotlivých funkcí nevolejte žádnou z funkcí
** implementovaných v rámci tohoto příkladu, není-li u funkce explicitně
 * uvedeno něco jiného.
**
** Nemusíte ošetřovat situaci, kdy místo legálního ukazatele na seznam
** předá někdo jako parametr hodnotu NULL.
**
** Svou implementaci vhodně komentujte!
**
** Terminologická poznámka: Jazyk C nepoužívá pojem procedura.
** Proto zde používáme pojem funkce i pro operace, které by byly
** v algoritmickém jazyce Pascalovského typu implemenovány jako procedury
** (v jazyce C procedurám odpovídají funkce vracející typ void).
**
**/

#include "c206.h"

int error_flag;
int solved;

/**
 * Vytiskne upozornění na to, že došlo k chybě.
 * Tato funkce bude volána z některých dále implementovaných operací.
 */
void DLL_Error() {
	printf("*ERROR* The program has performed an illegal operation.\n");
	error_flag = TRUE;
}

/**
 * Provede inicializaci seznamu list před jeho prvním použitím (tzn. žádná
 * z následujících funkcí nebude volána nad neinicializovaným seznamem).
 * Tato inicializace se nikdy nebude provádět nad již inicializovaným seznamem,
 * a proto tuto možnost neošetřujte.
 * Vždy předpokládejte, že neinicializované proměnné mají nedefinovanou hodnotu.
 *
 * @param list Ukazatel na strukturu dvousměrně vázaného seznamu
 */
void DLL_Init( DLList *list ) {
	// Inicializace prázdného seznamu
	list->firstElement = NULL;
	list->activeElement = NULL;
	list->lastElement = NULL;
}

/**
 * Zruší všechny prvky seznamu list a uvede seznam do stavu, v jakém se nacházel
 * po inicializaci.
 * Rušené prvky seznamu budou korektně uvolněny voláním operace free.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Dispose( DLList *list ) {
	// Seznam se stává neaktivním a poté se provádí cyklus, dokud nebude prázdný první prvek
	// Do dočasného prvku se vloží prvek následující a vymaže se prvek aktuálně první
	// Jako první prvek se nově nastaví aktuálně prvek následující a cyklus se opakuje
	list->activeElement = NULL;
	list->lastElement = NULL;
	while(list->firstElement != NULL) {
		DLLElementPtr temporaryElement;
		temporaryElement = list->firstElement->nextElement;
		free(list->firstElement);
		list->firstElement = temporaryElement;
	}
}

/**
 * Vloží nový prvek na začátek seznamu list.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení na začátek seznamu
 */
void DLL_InsertFirst( DLList *list, int data ) {
	// Alokace místa pro nový prvek pomocí operace malloc a její ošetření
	// Vložení hodnoty data do nového prvku, následník nového prvku je prvek první
	// Předchůdce není nastaven, pokud seznam nebyl prázdný, nový bude předchůdcem
	// Jinak bude nový zároveň posledním prvkem a nakonec se vždy nastaví jako první
	DLLElementPtr newElement = (DLLElementPtr) malloc(sizeof(struct DLLElement));
	if(newElement == NULL) {
		DLL_Error();
	}
	else {
		newElement->data = data;
		newElement->nextElement = list->firstElement;
		newElement->previousElement = NULL;
		if(list->firstElement != NULL) {
			list->firstElement->previousElement = newElement;
		}
		else {
			list->lastElement = newElement;
		}
		list->firstElement = newElement;
	}
}

/**
 * Vloží nový prvek na konec seznamu list (symetrická operace k DLL_InsertFirst).
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení na konec seznamu
 */
void DLL_InsertLast( DLList *list, int data ) {
	// Alokace místa pro nový prvek pomocí operace malloc a její ošetření
	// Vložení hodnoty data do nového prvku, předchůdce nového prvku je prvek poslední
	// Následník není nastaven, pokud seznam nebyl prázdný, nový bude následníkem
	// Jinak bude nový zároveň prvním prvkem a nakonec se vždy nastaví jako poslední
	DLLElementPtr newElement = (DLLElementPtr) malloc(sizeof(struct DLLElement));
	if(newElement == NULL) {
		DLL_Error();
	}
	else {
		newElement->data = data;
		newElement->previousElement = list->lastElement;
		newElement->nextElement = NULL;
		if(list->lastElement != NULL) {
			list->lastElement->nextElement = newElement;
		}
		else {
			list->firstElement = newElement;
		}
		list->lastElement = newElement;
	}
}

/**
 * Nastaví první prvek seznamu list jako aktivní.
 * Funkci implementujte jako jediný příkaz, aniž byste testovali,
 * zda je seznam list prázdný.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_First( DLList *list ) {
	// Aktivním prvkem se stává první prvek seznamu
	list->activeElement = list->firstElement;
}

/**
 * Nastaví poslední prvek seznamu list jako aktivní.
 * Funkci implementujte jako jediný příkaz, aniž byste testovali,
 * zda je seznam list prázdný.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Last( DLList *list ) {
	// Aktivním prvkem se stává poslední prvek seznamu
	list->activeElement = list->lastElement;
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu prvního prvku seznamu list.
 * Pokud je seznam list prázdný, volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetFirst( DLList *list, int *dataPtr ) {
	// Ošetření stavu voláním funkce DLL_Error(), pokud je seznam prázdný
	// Do proměnné dataPtr se uloží hodnota prvního prvku seznamu
	if(list->firstElement == NULL) {
		DLL_Error();
	}
	else {
		*dataPtr = list->firstElement->data;
	}
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu posledního prvku seznamu list.
 * Pokud je seznam list prázdný, volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetLast( DLList *list, int *dataPtr ) {
	// Ošetření stavu voláním funkce DLL_Error(), pokud je seznam prázdný
	// Do proměnné dataPtr se uloží hodnota posledního prvku seznamu
	if(list->lastElement == NULL) {
		DLL_Error();
	}
	else {
		*dataPtr = list->lastElement->data;
	}
}

/**
 * Zruší první prvek seznamu list.
 * Pokud byl první prvek aktivní, aktivita se ztrácí.
 * Pokud byl seznam list prázdný, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteFirst( DLList *list ) {
	// Je-li první prvek zároveň prvkem aktivním, stane se seznam neaktivním
	// Do dočasného prvku se vloží první prvek, jestliže je první prvek zároveň
	// poslední, jedná se o jednočlenný seznam, který se kompletně zruší
	// Jinak se stává prvním prvkem následník a uvolní se paměť po původním prvku
	if(list->firstElement != NULL) {
		if(list->firstElement == list->activeElement) {
			list->activeElement = NULL;
		}
		DLLElementPtr temporaryElement;
		temporaryElement = list->firstElement;
		if(list->firstElement == list->lastElement) {
			list->firstElement = NULL;
			list->lastElement = NULL;
		}
		else {
			list->firstElement = list->firstElement->nextElement;
			list->firstElement->previousElement = NULL;
		}
		free(temporaryElement);
	}
}

/**
 * Zruší poslední prvek seznamu list.
 * Pokud byl poslední prvek aktivní, aktivita seznamu se ztrácí.
 * Pokud byl seznam list prázdný, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteLast( DLList *list ) {
	// Je-li poslední prvek zároveň prvkem aktivním, stane se seznam neaktivním
	// Do dočasného prvku se vloží poslední prvek, jestliže je poslední prvek zároveň
	// první, jedná se o jednočlenný seznam, který se kompletně zruší
	// Jinak se stává posledním prvkem předchůdce a uvolní se paměť po původním prvku
	if(list->lastElement != NULL) {
		if(list->lastElement == list->activeElement) {
			list->activeElement = NULL;
		}
		DLLElementPtr temporaryElement;
		temporaryElement = list->lastElement;
		if(list->lastElement == list->firstElement) {
			list->lastElement = NULL;
			list->firstElement = NULL;
		}
		else {
			list->lastElement = list->lastElement->previousElement;
			list->lastElement->nextElement = NULL;
		}
		free(temporaryElement);
	}
}

/**
 * Zruší prvek seznamu list za aktivním prvkem.
 * Pokud je seznam list neaktivní nebo pokud je aktivní prvek
 * posledním prvkem seznamu, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteAfter( DLList *list ) {
	// Není-li aktivní prvek ani následník aktivního prvku prázdný, do dočasného prvku
	// se uloží následník aktivního a poté se do tohoto prvku uloží další následník
	// Pokud je rušený prvek zároveň posledním, stává se poslední prvek aktivním
	// Jinak předchůdce následníka zrušeného prvku bude prvek aktivní
	// Nakonec se uvolní paměť zrušeného prvku
	if(list->activeElement != NULL) {
		if(list->activeElement->nextElement != NULL) {
			DLLElementPtr temporaryElement;
			temporaryElement = list->activeElement->nextElement;
			list->activeElement->nextElement = temporaryElement->nextElement;
			if(temporaryElement == list->lastElement) {
				list->lastElement = list->activeElement;
			}
			else {
				temporaryElement->nextElement->previousElement = list->activeElement;
			}
			free(temporaryElement);
		}
	}
}

/**
 * Zruší prvek před aktivním prvkem seznamu list .
 * Pokud je seznam list neaktivní nebo pokud je aktivní prvek
 * prvním prvkem seznamu, nic se neděje.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_DeleteBefore( DLList *list ) {
	// Není-li aktivní prvek ani předchůdce aktivního prvku prázdný, do dočasného prvku
	// se uloží předchůdce aktivního a poté se do tohoto prvku uloží další předchůdce
	// Pokud je rušený prvek zároveň prvním, stává se první prvek aktivním
	// Jinak následník předchůdce zrušeného prvku bude prvek aktivní
	// Nakonec se uvolní paměť zrušeného prvku
	if(list->activeElement != NULL) {
		if(list->activeElement->previousElement != NULL) {
			DLLElementPtr temporaryElement;
			temporaryElement = list->activeElement->previousElement;
			list->activeElement->previousElement = temporaryElement->previousElement;
			if(temporaryElement == list->firstElement) {
				list->firstElement = list->activeElement;
			}
			else {
				temporaryElement->previousElement->nextElement = list->activeElement;
			}
			free(temporaryElement);
		}
	}
}

/**
 * Vloží prvek za aktivní prvek seznamu list.
 * Pokud nebyl seznam list aktivní, nic se neděje.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení do seznamu za právě aktivní prvek
 */
void DLL_InsertAfter( DLList *list, int data ) {
	// Alokace místa pro nový prvek pomocí operace malloc a její ošetření
	// Vložení hodnoty data do nového prvku, následník nového prvku je následník aktivního
	// Předchůdce je právě aktivní prvek a následníkem aktivního je nový prvek
	// Je-li poslední prvek aktivní, stává se posledním prvkem vložený prvek
	// Jinak se předchůdcem následníka nového prvku stává vložený prvek
	if(list->activeElement != NULL) {
		DLLElementPtr newElement = (DLLElementPtr) malloc(sizeof(struct DLLElement));
		if(newElement == NULL) {
			DLL_Error();
		}
		else {
			newElement->data = data;
			newElement->nextElement = list->activeElement->nextElement;
			newElement->previousElement = list->activeElement;
			list->activeElement->nextElement = newElement;
			if(list->activeElement == list->lastElement) {
				list->lastElement = newElement;
			}
			else {
				newElement->nextElement->previousElement = newElement;
			}
		}
	}
}

/**
 * Vloží prvek před aktivní prvek seznamu list.
 * Pokud nebyl seznam list aktivní, nic se neděje.
 * V případě, že není dostatek paměti pro nový prvek při operaci malloc,
 * volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Hodnota k vložení do seznamu před právě aktivní prvek
 */
void DLL_InsertBefore( DLList *list, int data ) {
	// Alokace místa pro nový prvek pomocí operace malloc a její ošetření
	// Vložení hodnoty data do nového prvku, následník nového prvku je aktivní
	// Předchůdce je předchůdce aktivního a předchůdcem aktivního je nový prvek
	// Je-li první prvek aktivní, stává se prvním prvkem vložený prvek
	// Jinak se následníkem předchůdce nového prvku stává vložený prvek
	if(list->activeElement != NULL) {
		DLLElementPtr newElement = (DLLElementPtr) malloc(sizeof(struct DLLElement));
		if(newElement == NULL) {
			DLL_Error();
		}
		else {
			newElement->data = data;
			newElement->nextElement = list->activeElement;
			newElement->previousElement = list->activeElement->previousElement;
			list->activeElement->previousElement = newElement;
			if(list->activeElement == list->firstElement) {
				list->firstElement = newElement;
			}
			else {
				newElement->previousElement->nextElement = newElement;
			}
		}
	}
}

/**
 * Prostřednictvím parametru dataPtr vrátí hodnotu aktivního prvku seznamu list.
 * Pokud seznam list není aktivní, volá funkci DLL_Error().
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param dataPtr Ukazatel na cílovou proměnnou
 */
void DLL_GetValue( DLList *list, int *dataPtr ) {
	// Ošetření stavu voláním funkce DLL_Error(), pokud je seznam prázdný
	// Do proměnné dataPtr se uloží hodnota aktivního prvku seznamu
	if(list->activeElement == NULL) {
		DLL_Error();
	}
	else {
		*dataPtr = list->activeElement->data;
	}
}

/**
 * Přepíše obsah aktivního prvku seznamu list.
 * Pokud seznam list není aktivní, nedělá nic.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 * @param data Nová hodnota právě aktivního prvku
 */
void DLL_SetValue( DLList *list, int data ) {
	// Je-li seznam aktivní, uloží se hodnota data do aktivního prvku
	if(list->activeElement != NULL) {
		list->activeElement->data = data;
	}
}

/**
 * Posune aktivitu na následující prvek seznamu list.
 * Není-li seznam aktivní, nedělá nic.
 * Všimněte si, že při aktivitě na posledním prvku se seznam stane neaktivním.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Next( DLList *list ) {
	// Je-li seznam aktivní, stává se novým aktivním prvkem prvek následující
	if(list->activeElement != NULL) {
		list->activeElement = list->activeElement->nextElement;
	}
}


/**
 * Posune aktivitu na předchozí prvek seznamu list.
 * Není-li seznam aktivní, nedělá nic.
 * Všimněte si, že při aktivitě na prvním prvku se seznam stane neaktivním.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 */
void DLL_Previous( DLList *list ) {
	// Je-li seznam aktivní, stává se novým aktivním prvkem prvek předchozí
	if(list->activeElement != NULL) {
		list->activeElement = list->activeElement->previousElement;
	}
}

/**
 * Je-li seznam list aktivní, vrací nenulovou hodnotu, jinak vrací 0.
 * Funkci je vhodné implementovat jedním příkazem return.
 *
 * @param list Ukazatel na inicializovanou strukturu dvousměrně vázaného seznamu
 *
 * @returns Nenulovou hodnotu v případě aktivity prvku seznamu, jinak nulu
 */
int DLL_IsActive( DLList *list ) {
	// Pokud je seznam aktivní, podmínka se vyhodnotí jako TRUE, jinak FALSE
	return (list->activeElement != NULL);
}

/* Konec c206.c */
