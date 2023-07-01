; Autor reseni: David Kvacek xkvace00
; Registry: r22(s6)-r23(s7)-r8(t0)-r17(s1)-r0(zero)-r4(a0)

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "xkvace00"              ; sem doplnte vas login
first_key:      .word   11                      ; prvni sifrovaci znak (posun vpred)
first_key_inv:  .word   -15                     ; prvni sifrovaci znak pri preteceni (posun vzad)
second_key:     .word   -22                     ; druhy sifrovaci znak (posun vzad)
second_key_inv: .word   4                       ; druhy sifrovaci znak pri preteceni (posun vpred)
cipher:         .space  17                      ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8                       ; misto pro ulozeni adresy pocatku
                                                ; retezce pro vypis pomoci syscall 5
                                                ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text
main:                                           ; hlavni cast programu
forward_shift:  xor     r4, r4, r4              ; vynulovani registru r4 operaci xor
                xor     r8, r8, r8              ; vynulovani registru r8 operaci xor
                xor     r17, r17, r17           ; vynulovani registru r17 operaci xor
                lb      r4, login(r23)          ; nacteni znaku z retezce login na pozici r23 do registru r4
                slti    r8, r4, 97              ; r8 = 0, pokud je r4 vetsi nebo rovno 97, jinak r8 = 1
                bne     r8, r0, end             ; jestlize r8 = 0, sifrujeme dale, jinak konec sifrovani a vypiseme retezec cipher
                lb      r8, first_key(r0)       ; nacteni kladneho posunu do registru r8
                dadd    r8, r4, r8              ; pricteni posunu k nactenemu znaku v r4 do registru r8
                slti    r17, r8, 123            ; r17 = 0, pokud je r8 vetsi nebo rovno 123, jinak r17 = 1
                beq     r17, r0, for_overflow   ; jestlize r17 = 0, zasifrovany znak neni v rozsahu
                sb      r8, cipher(r23)         ; ulozeni zasifrovaneho znaku do promenne cipher na index r23
                daddi   r23, r23, 1             ; inkrementace citace v registru r23
                j       backward_shift          ; skok na sifrovani sudeho znaku (posun vzad)

for_overflow:   lb      r8, first_key_inv(r0)   ; nacteni zaporneho posunu do registru r8
                dadd    r8, r4, r8              ; pricteni posunu k nactenemu znaku v r4 do registru r8
                sb      r8, cipher(r23)         ; ulozeni zasifrovaneho znaku do promenne cipher na index r23
                daddi   r23, r23, 1             ; inkrementace citace v registru r23
                j       backward_shift          ; skok na sifrovani sudeho znaku (posun vzad)

backward_shift: xor     r4, r4, r4              ; vynulovani registru r4 operaci xor
                xor     r8, r8, r8              ; vynulovani registru r8 operaci xor
                xor     r17, r17, r17           ; vynulovani registru r17 operaci xor
                lb      r4, login(r23)          ; nacteni znaku z retezce login na pozici r23 do registru r4
                slti    r8, r4, 97              ; r8 = 0, pokud je r4 vetsi nebo rovno 97, jinak r8 = 1
                bne     r8, r0, end             ; jestlize r8 = 0, sifrujeme dale, jinak konec sifrovani a vypiseme retezec cipher
                lb      r8, second_key(r0)      ; nacteni zaporneho posunu do registru r8
                dadd    r8, r4, r8              ; pricteni posunu k nactenemu znaku v r4 do registru r8
                slti    r17, r8, 97             ; r17 = 0, pokud je r8 vetsi nebo rovno 97, jinak r17 = 1
                bne     r17, r0, back_overflow  ; jestlize r17 neni 0, zasifrovany znak neni v rozsahu
                sb      r8, cipher(r23)         ; ulozeni zasifrovaneho znaku do promenne cipher na index r23
                daddi   r23, r23, 1             ; inkrementace citace v registru r23
                j       forward_shift           ; skok na sifrovani licheho znaku (posun vpred)

back_overflow:  lb      r8, second_key_inv(r0)  ; nacteni kladneho posunu do registru r8
                dadd    r8, r4, r8              ; pricteni posunu k nactenemu znaku v r4 do registru r8
                sb      r8, cipher(r23)         ; ulozeni zasifrovaneho znaku do promenne cipher na index r23
                daddi   r23, r23, 1             ; inkrementace citace v registru r23
                j       forward_shift           ; skok na sifrovani licheho znaku (posun vpred)

end:            sb      r0, cipher(r23)         ; vlozeni ukoncujiciho znaku '\0' na konec retezce
                daddi   r4, r0, cipher          ; vypis sifrovaneho retezce: adresa cipher: do r4
                jal     print_string            ; vypis pomoci print_string - viz nize
                syscall 0                       ; halt

print_string:   sw      r4, params_sys5(r0)     ; adresa retezce se ocekava v r4
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5                       ; systemova procedura - vypis retezce na terminal
                jr      r31                     ; return - r31 je urcen na return address
