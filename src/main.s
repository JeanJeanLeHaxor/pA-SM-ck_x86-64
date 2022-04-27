global _start

section .text

_start:
    mov     rbp, rsp

    pop rax ; nb arg check < 2
    cmp rax, 0x2
    jl error_arg

    pop rax  ; remove argv[0]

    pop rdi ; get binary with argv[1]
    mov     rax, 0x2

    jmp _exit


error_arg:
    lea rsi, miss_arg
    mov rax, 0x1
    mov rdi, 0x1
    mov rdx, 0x1e
    syscall

_exit
    mov rax, 0x3c
    mov rdi, 0x0
    syscall

section .data
    miss_arg: db "Usage: pA-SM-ck_x86-64 binary", 0xa