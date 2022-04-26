global _start

section .text

_start:
    push    rbp
    mov     rsp, rbp
    sub     rsp, 0x8

    call    setup_heap

    call    clear_heap
    mov     rax, 0
    ret

setup_heap:
    mov     rax, 0xc
    mov     rdi, 0x0
    syscall             ; brk(NULL)
    mov     [rbp - 0x8], rax         ; save the heap start point


clear_heap:
    mov rax, 0xc
    mov rdi, [rbp - 0x8]
    syscall
//c
    save_heap = brk(NULL);
    addr = sbrk(20);

    ....
    ...addr[0] = 'c';
    printf("%c", addr[0]);
    ...

    brk(save_heap)

section .data
    payload: db "SALUT"