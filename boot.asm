[BITS 16]
[ORG 0x7C00]

section .text
start:
    ; Desactivar interrupciones
    cli

    ; Configurar los segmentos
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Cargar el mensaje de inicio
    mov si, boot_msg
    call print_string

    ; Cargar el kernel desde el disco (asumiendo que está en los siguientes sectores)
    mov bx, 0x1000         ; Dirección en la memoria donde se cargará el kernel
    mov dh, 0              ; Cabeza 0
    mov dl, 0x80           ; Unidad (disco duro)
    mov ch, 0              ; Pista 0
    mov cl, 2              ; Sector 2 (el primer sector después del MBR)
    mov ah, 0x02           ; Función BIOS: Leer sectores
    mov al, 1              ; Número de sectores a leer
    int 0x13
    jc disk_error          ; Si hay un error, saltar a disk_error

    ; Cargar el GDT
    lgdt [gdt_descriptor]

    ; Habilitar el modo protegido
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Saltar al modo protegido
    jmp 0x08:protected_mode

disk_error:
    mov si, error_msg
    call print_string
    hlt

gdt_start:
gdt_null:
    dq 0x0000000000000000
gdt_code:
    dq 0x00cf9a000000ffff
gdt_data:
    dq 0x00cf92000000ffff
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
protected_mode:
    ; Configurar los segmentos en modo protegido
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Configurar la pila
    mov esp, 0x90000

    ; Saltar al kernel cargado
    call 0x1000

hang:
    hlt
    jmp hang

print_string:
    mov ah, 0x0E
.repeat:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .repeat
.done:
    ret

boot_msg db 'Loading kernel...', 0
error_msg db 'Disk read error', 0

times 510-($-$$) db 0
dw 0xAA55
