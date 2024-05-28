global _start
_start:
    mov rax, 1
    mov rdi, 'H'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'e'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'l'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'l'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'o'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, ' '
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'W'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'o'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'r'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'l'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, 'd'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 1
    mov rdi, '!'
    mov rsi, 0
    mov rdx, 0
    int 0x80
    mov rax, 0
    mov rdi, 0
    mov rsi, 0
    mov rdx, 0
    int 0x80