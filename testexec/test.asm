global _start
_start:
    mov rax, 1
    mov rdi, 'A'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 's'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 's'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 0
    mov rdi, 0
    mov rsi, 0
    mov rdx, 0
    int 0x80