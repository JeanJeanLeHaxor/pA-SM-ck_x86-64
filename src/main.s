; ----------------[  Macros  ]---------------- ;

%macro      brk 2
    mov     rax, 0xc
    mov     rdi, %1
    add     rdi, %2
    syscall 
%endmacro

%macro      mprotect  3
    mov     rax, 0xa
    mov     rdi, %1 ; start address
    mov     rsi, %2 ; size of mprotect
    mov     rdx, %3 ; prot flags
    syscall
%endmacro

; -------------------------------------------- ;

global _start

section .text

_start:
    mov     rbp, rsp
    push    rbp
    sub     rsp, 0x8

    call    setup_heap
    call    allocated_space

    mprotect [rbp - 0x8], 0x1000, 0x7

    mov     rax, [rbp - 0x8]
    mov     BYTE [rax], 0x41

    mov     rsi, rax
    mov     rax, 0x1
    mov     rdi, 0x1
    mov     rdx, 0x1    
    syscall

    call    clear_heap
    mov     rax, 0

    call _exit

setup_heap:
    brk     0x0, 0x0
    mov     [rbp - 0x8], rax    ; save the heap start point
    ret

allocated_space:
    brk     [rbp - 0x8], 0x100                   ; brk(heapStart + rdi) -> Allocate rdi on the heap
    ret

clear_heap:
    mov     rax, 0xc
    mov     rdi, [rbp - 0x8]
    syscall
    ret

;mprotect:
;    mov     rax, 0xa
;    mov     rdi, [rbp - 0x8]
;    mov     rsi, 0x1000
;    mov     rdx, 0x1
;    or      rdx, 0x2
;    or      rdx, 0x4
;    syscall
;    ret

_exit:
    pop rsp
    mov     rax, 0x3c
    mov     rdi, 0x0
    syscall

section .data
    payload: db "SALUT"
