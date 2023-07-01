%include "rw32-2018.inc"
CEXTERN qsort

section .data
	pFloatArr dd 13.8, 14.0, 11.5, 11.55, 1.3, 85.2, 92.0, 10.2

section .text

;	  sin(-2x + pi)
; f(x) = --------------
;	      x - 7

task31:
	push ebp
	mov ebp, esp
	
	push eax
	push __float32__(-2.0)
	push __float32__(7.0)
	
	fld dword [ebp - 8]
	fld dword [ebp - 4]
	
	fmul
	fldpi
	faddp
	fsin
	
	fld dword [ebp - 4]
	fld dword [ebp - 12]
	
	fsubp
	fldz
	fcomip
	jz .end
	
	fdiv
	fst dword [ebp - 4]
	mov eax, [ebp - 4]
	
.end:
	add esp, 12
	
	pop ebp
	ret

; int task32(float *pA, float *pB, unsigned int N) {
; 	if(pB != NULL && pA != NULL && N > 0) {
; 		memcpy(pB, pA, N*sizeof(float));
; 		for(unsigned int i = 0; i < N; i++) {
; 			pA[i] = task 31(pA[i]);
; 			}
; 		return 1;
; 		}
; 	return 0;
; }

task32:
	push ebp
	mov ebp, esp
	
	xor eax, eax
	cmp eax, [ebp + 8]
	je .end
	cmp eax, [ebp + 12]
	je .end
	cmp eax, [ebp + 16]
	je .end
	
	push eax
	push ebx
	push ecx
	push edx
	
	mov eax, [ebp + 16]
	mov ebx, 4
	
	mul ebx
	
	mov ebx, [ebp + 12]
	mov ecx, [ebp + 8]
	
	push eax
	push ecx
	push ebx
	call memcpy
	add esp, 12
	
	xor ebx, ebx
	mov ecx, [ebp + 8]
	
.for:
	cmp ebx, [ebp + 16]
	jae .forend
	
	mov eax, [ecx + ebx * 4
	call task31
	mov [ecx + ebx * 4]
	
	inc ebx
	jmp .for
.forend:
	
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	mov eax, 1
.end:
	
	pop ebp
	ret


; __cdecl__ int float_comp(*p1, *p2);
float_comp:
	push ebp
	mov ebp, esp
	
	push ebx
	
	mov eax, [ebp + 8]
	mov ebx, [ebp + 12]
	
	fld dword [eax]
	fld dword [ebx]
	
	xor eax, eax
	fcomip
	je .end
	ja .p2higher
	
	mov eax, 1
	jmp .end
	
.p2higher:
	mov eax, -1
	
.end:
	fstp st0
	pop ebx
	
	pop ebp
	ret
	
_main:
	push ebp
	mov ebp, esp
	
	; call qsort(void *array, size_t n, size_t sizeOfElement, *ptr to comp func);
	push float_comp
	push dword 4
	push dword 8
	push dword pFloatArr
	call qsort
	add esp, 16
	
	pop ebp
	ret
