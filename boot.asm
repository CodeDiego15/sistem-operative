[BITS 16]
[ORG 0x7C00]

start:
    ; Inicializar los segmentos
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Configurar la pantalla
    mov si, msg
print_char:
    lodsb
    or al, al
    jz $
    mov ah, 0x0E
    int 0x10
    jmp print_char

msg db 'Hello, OS!', 0

times 510-($-$$) db 0
dw 0xAA55
