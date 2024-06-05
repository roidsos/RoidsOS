global _start
_start:
    mov rax, 1
    mov rdi, 'H'
    syscall 
    mov rax, 1
    mov rdi, 'e'
    syscall
    mov rax, 1
    mov rdi, 'l'
    syscall
    mov rax, 1
    mov rdi, 'l'
    syscall
    mov rax, 1
    mov rdi, 'o'
    syscall
    mov rax, 1
    mov rdi, ' '
    syscall
    mov rax, 1
    mov rdi, 'W'
    syscall
    mov rax, 1
    mov rdi, 'o'
    syscall
    mov rax, 1
    mov rdi, 'r'
    syscall
    mov rax, 1
    mov rdi, 'l'
    syscall
    mov rax, 1
    mov rdi, 'd'
    syscall
    mov rax, 1
    mov rdi, '!'
    syscall
    mov rax, 0
    mov rdi, 0
    syscall