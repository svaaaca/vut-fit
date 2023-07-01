%include "rw32-2022.inc"

section .data
msg1    db "S = ", 0
msg2    db "x = ", 0
msg3    db "EAX = ", 0
a       dw 7
b       dw 3
h       dw 5
arr     dw 7, 3, 5, 2
prices  dd 25, 20, 21
ntimes  dw 5, 1, 3

section .text
CMAIN:
    mov ebp, esp
    push ebp
    
    ; Ukol 1: vypocitejte obsah lichobezniku S = (a + b) / 2 * h.
    mov al, [a]
    add al, [b]
    cbw
    
    mov bl, 2
    idiv bl
    
    mov bl, [h]
    imul bl
    
    mov esi, msg1
    call WriteString
    call WriteInt16
    call WriteNewLine
    
    ; Ukol 2: vytvorte pole se ctyrmi 16 bitovymi prvky,
    ; nasledne vypoctete vyraz x = arr[0]^2 + arr[1] + arr[2] / (-2 * arr[3]).
    mov ax, [arr]
    mov bx, [arr]
    xor dx, dx
    imul bx
    
    mov cx, ax
    add cx, [arr + 2]
    
    mov ax, [arr + 6]
    mov bx, -2
    xor dx, dx
    imul bx
    
    mov bx, ax
    
    mov ax, [arr + 4]
    cwd
    idiv bx
    add cx, ax
    mov ax, cx
    
    mov esi, msg2
    call WriteString
    call WriteInt16
    call WriteNewLine
    
    ; Ukol 3: pivni priklad, 
    ; prvni pivo (Polotmavy demon) stoji 25 Kc,
    ; druhe pivo (Policka) stoji 20 Kc,
    ; treti pivo (Pater) stoji 21 Kc,
    ; vasim ukolem je udelat pivni kalkulacku, vysledna cena bude v registru EAX,
    ; ceny jednotlivych piv ulozte do pole o velikosti 32 bitu,
    ; pocty vypitych piv pak do pole o velikosti 16 bitu,
    ; pozice v poli vypitych piv bude odpovidat typu piva v prvnim poli.
    mov ax, [ntimes]
    cwde
    mov ebx, [prices]
    xor edx, edx
    imul ebx
    mov ecx, eax
    
    mov ax, [ntimes + 2]
    cwde
    mov ebx, [prices + 4]
    xor edx, edx
    imul ebx
    add ecx, eax
    
    mov ax, [ntimes + 4]
    cwde
    mov ebx, [prices + 8]
    xor edx, edx
    imul ebx
    add ecx, eax
    mov eax, ecx
    
    mov esi, msg3
    call WriteString
    call WriteInt32
    call WriteNewLine
    
    pop ebp
    ret
