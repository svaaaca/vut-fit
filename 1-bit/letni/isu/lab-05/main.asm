%include "rw32-2022.inc"

section .text
CMAIN:
    mov ebp, esp
    push ebp

    ; EAX / 2
    mov eax, 100
    sar eax, 1
    call WriteInt32
    call WriteNewLine
    
    ; EAX * 8
    sal eax, 3
    call WriteInt32
    call WriteNewLine
    
    ; neg(EAX) / 4
    neg eax
    sar eax, 2
    call WriteInt32
    call WriteNewLine
    
    ;   A  |  B  |  C  |  D
    ; neg(C) + B |  D * A
    mov eax, 0x0207FF04
    ror eax, 8
    neg al
    add al, ah
    cbw
    ror eax, 16
    mul ah

    pop ebp
    ret
