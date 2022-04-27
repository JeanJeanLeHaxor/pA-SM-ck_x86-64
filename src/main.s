global _start

section .text

_start:
    mov     rbp, rsp
    sub     rsp, 0x100

    pop     rax                 ; get the number of arguments
    cmp     rax, 0x2            ; check how many arguments there's
    jl      throw_error_arg     ; if no args then throw the usage error message

    pop     rax                 ; remove argv[0]

    pop     rdi                 ; get binary with argv[1]
    mov     rax, 0x2
    mov     rsi, 0x0            ; RDONLY
    syscall

    ;to-do error file open

    mov rdi, rax
    pop rsi
    call copy_binary

    jmp _exit



copy_binary:
    push    rdi             ; file to copy
    mov     rax,    0x2
    mov     rdi,    rsi     ; file_name
    mov     rsi,    0x441   ; WRONLY | CREATE | APPEND 
    syscall
    pop rdi
    push rax ; file to create

copy_binary_while:
    mov rax, 0x1
    syscall


end_binary_while:
    ret


throw_error_arg:
    lea rsi, [miss_arg]
    mov rax, 0x1
    mov rdi, 0x1
    mov rdx, len_miss_arg
    syscall

_exit
    mov rax, 0x3c
    mov rdi, 0x0
    syscall

section .data
    miss_arg: db "Usage: pA-SM-ck_x86-64 binary packer", 0xa
    len_miss_arg: equ $-miss_arg