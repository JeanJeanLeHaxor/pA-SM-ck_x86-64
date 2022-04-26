global main

main:
    call setup_heap
    mov rax, 0
    ret

setup_heap:
    mov rax, 0xc
    mov rdi, 0x0
    syscall

.data
    payload: "SALUT"