global _start

section .text

_start:
    push    rbp
    mov     rsp, rbp
    sub     rsp, 0x8

    call    setup_heap

    call    allocated_space

    call    clear_heap
    mov     rax, 0
    ret

setup_heap:
    mov     rax, 0xc
    mov     rdi, 0x0
    syscall                     ; brk(NULL)

    mov     [rbp - 0x8], rax    ; save the heap start point
    ret

allocated_space:
    mov     rax, 0xc
    mov     rdi, 0x20
    syscall
    ret

clear_heap:
    mov     rax, 0xc
    mov     rdi, [rbp - 0x8]
    syscall
    ret

section .data
    payload: db "SALUT"