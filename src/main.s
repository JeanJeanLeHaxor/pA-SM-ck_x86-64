; ----------------[  Macros  ]---------------- ;

%macro      brk 2
    mov     rax, 0xc
    mov     rdi, %1
    add     rdi, %2
    syscall 
%endmacro

%macro      mprotect    3
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

    pop     rax                 ; get the number of arguments
    cmp     rax, 0x2            ; check how many arguments there's
    jl      throw_error_arg     ; if no args then throw the usage error message

    pop     rax                 ; remove argv[0]
    pop     rdi                 ; store filename of argv[1]

    call    open_src            ; open source file

    call    setup_space         ; allocate space for source file

    pop     r13                 ; save argv[2] in r12

    mov     rsi, r14            ; location to read
    call    read_src            ; open destination file
    
    ; je me suis arreté ici (dans le programme je backup le début de la heap dans r14)
    call copy_binary

    jmp _exit

open_src:
    mov     rax, 0x2            ; open(rdi)
    mov     rsi, 0x2            ; O_RDWR
    syscall
    mov     r12, rax            ; save file descriptor of src
    cmp     rax, 0              ; check if file was opened
    jl      _exit               ; jmp to _exit if error
    ret

read_src:
    mov     rdi, r12            ; get file descriptor
    mov     rax, 0x0            ; read syscall
    mov     rdx, 0x8            ; size
    syscall
    add     rsi, 0x8
    cmp     rax, 0x8
    jz      read_src
    ret

setup_space:
    brk     0x0, 0x0
    mov     r14, rax            ; save start of the heap in r14
    brk     r14, 0x10000        ; allocate a 0x1000 bytes page
    ret

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