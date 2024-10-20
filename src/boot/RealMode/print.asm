[bits 16]

print_BIOS:
    push ax
    push bx

    ; Enters print mode
    mov ah, 0x0E

    print_BIOS_loop:
        ; Basically a nullptr check
        cmp byte[bx], 0
        je print_BIOS_end

        ; Prints a character
        mov al, byte[bx]
        int 0x10

        ; Increments the pointer so we get to the next character.
        ; Also restarts the loop so we can actually print the next character.
        inc bx
        jmp print_BIOS_loop


print_BIOS_end:
    pop bx
    pop ax

    ret