global _start

section .text

_start:
    mov     rbp, rsp
    push    rbp
    sub     rsp, 0x8

    call    setup_heap

    call    allocated_space
    call    mprotect

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
    mov     rax, 0xc
    mov     rdi, 0x0
    syscall                     ; brk(NULL)

    mov     [rbp - 0x8], rax    ; save the heap start point
    ret

allocated_space:
    mov     rax, 0xc
    mov     rdi, [rbp - 0x8]
    add     rdi, 0x20
    syscall
    ret

clear_heap:
    mov     rax, 0xc
    mov     rdi, [rbp - 0x8]
    syscall
    ret

mprotect:
    mov     rax, 0xa
    mov     rdi, [rbp - 0x8]
    mov     rsi, 0x1000
    mov     rdx, 0x3
    syscall

_exit:
    pop rsp
    mov     rax, 0x3c
    mov     rdi, 0x0
    syscall

section .data
    payload: db "SALUT"