%include "rw32-2022.inc"

section .data
; Ukol 1: Definujte spravny datovy typ (nejmensi mozny). Proc jste ho pouzil(a)?
cislo1   db   235
cislo2   dw   64789
cislo3   dw   257

cisla    dw   7541, 541, 42
retez1   db   "wxxx", 0
retez2   db   "xxxd", 0

section .bss
vysledek resw 1

section .text
CMAIN:
    ; Ukol 2: ulozte do vyhrazene pameti "vysledek" vypoctu cisla[0] - cisla[1] + cisla[2]
    ; potrebne instrukce: mov, add, sub (muzete pouzit cheat sheet)
    ; povsimnete si, ze sirka cisel je 16b
    
    mov ebp, esp
    push ebp
    
    mov ax, [cisla]
    sub ax, [cisla + 2]
    add ax, [cisla + 4]
    mov [vysledek], ax
    
    ; vypis vysledku pro kontrolu, kod prosim nemente
    mov ax, [vysledek]
    call WriteUInt16
    call WriteNewLine
    
    ; Ukol 3: upravte retezec "retez" tak, aby obsahoval 4 po sobe nasledujici pismena, tzn.
    ; jestlize "retez1" je na pocatku "axyz" upravte jej na "abcd", tzn. nactete prvni pismeno a opravte stavajici 3
    ; v tomhle cviceni prosim nepouzivejte cykly
    ; potrebne instrukce: mov, add / inc
    ; Napoveda: ASCII tabulka
  
    mov ah, [retez1]
    add ah, byte 1
    mov [retez1 + 1], ah
    add ah, byte 1
    mov [retez1 + 2], ah
    add ah, byte 1
    mov [retez1 + 3], ah
    
    ; vypis vysledku pro kontrolu, kod prosim nemente
    mov esi, retez1
    call WriteString
    call WriteNewLine
    
    ; Ukol 4: Upravte retezec "retez2" tak, aby obsahoval 4 po sobe nasledujici pismena, tzn.
    ; jestlize "retez2" je na zacatku "xxxz" upravte jej na "wxyz", tzn. nactete posledni pismeno a opravte stavajici 3
    ; v tomto cviceni prosim nepouzivejte cykly
    ; potrebne instrukce: mov, sub / dec
    
    mov al, [retez2 + 3]
    sub al, byte 1
    mov [retez2 + 2], al
    sub al, byte 1
    mov [retez2 + 1], al
    sub al, byte 1
    mov [retez2], al
    
    ; Otazka: Muzete pouzit 32bit registr? Zduvodnete.
    ; 32bit registr pouzit nemuzeme, protoze jednotlive znaky bereme jako typ db (byte), coz je 8bit hodnota
    
    
    ; vypis vysledku pro kontrolu, kod prosim nemente
    mov esi, retez2
    call WriteString
    
    ; konec
    xor eax, eax
    
    pop ebp
    ret
