%include "rw32-2018.inc"

extern _time
extern _printf
extern _rand
extern _srand

section .data
    string db "%d|"
    const dd 10

section .text
_main:
    push ebp
    mov ebp, esp

    mov ecx, 1
for:
    push ecx
    mov eax, [const]
    mul ecx
    push eax
    push string
    call _printf
    add esp, 8
    pop ecx
    inc ecx
    cmp ecx, 10
    jnle end
    jmp for
end:

    call ReadInt32
    push eax
    call _PrintRandom
    add esp, 4

    pop ebp
    ret

_PrintRandom:
    push ebp
    mov ebp, esp
    
    
    push 0
    call _time
    add esp, 4
    
    push eax
    call _srand
    add esp, 4
    
    call _rand
    call _rand

    mov ecx, [ebp + 8]
for2:
    push ecx
    call _rand
    pop ecx
    
    call WriteNewLine
    call WriteUInt32
    
    loop for2
    
    pop ebp
    ret