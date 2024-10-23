[bits 16]

print_hex_BIOS:
    push ax
    push bx
    push cx

    ; Enters print mode
    mov ah, 0x0E

    mov al, '0'
    int 0x10
    mov al, 'x'
    int 0x10

    ; Inits CX as the counter
    mov cx, 4

    print_hex_BIOS_loop:

        cmp cx, 0
        je print_hex_BIOS_end

        push bx

        ; Shifts so the upper 4 bits will be the lower 4 bits
        shr bx, 12

        ; Hex uses letters for numbers 10 to 16
        cmp bx, 10
        jge print_hex_BIOS_alpha

        ; The byte in bx should now be less than 10
        mov al, '0'
        add al, bl

        jmp print_hex_BIOS_loop_end

        print_hex_BIOS_alpha:
            sub bl, 10
            mov al, 'A'
            mov al, bl
        print_hex_BIOS_loop_end:
            int 0x10
            pop bx
            shl bx, 4
            dec cx

            jmp print_hex_BIOS_loop

print_hex_BIOS_end:
    pop cx
    pop bx
    pop ax

    ret