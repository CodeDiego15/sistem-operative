[BITS 16]
[ORG 0x7C00]

start:
    ; Setup the stack
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Print a message
    mov si, msg
print_char:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp print_char

load_kernel:
    ; Set up 32-bit protected mode
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 08h:init32

[BITS 32]
init32:
    mov ax, 10h
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call kernel_main
hang:
    cli
    hlt

gdt_start:
    dq 0x0000000000000000
    dq 0x00cf9a000000ffff
    dq 0x00cf92000000ffff
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

msg db 'Loading kernel...', 0

times 510-($-$$) db 0
dw 0xAA55
