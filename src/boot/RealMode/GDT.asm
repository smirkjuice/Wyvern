[bits 16]

gdt_32_start:
    ; Defines the null sector the 32-bit GDT (Global Descriptor Table).
    ; The null sector is needed for memory integrity checks.
    gdt_32_null:
        dd 0x00000000
        dd 0x00000000

    ; Defines the code sector for the 32-bit GDT
    gdt_32_code:
        ; Representation of the GDT
        ; Base:     0x00000
        ; Limit:    0xFFFFF
        ; 1st Flags:        0b1001
        ;   Present:        1
        ;   Privelege:      00
        ;   Descriptor:     1
        ; Type Flags:       0b1010
        ;   Code:           1
        ;   Conforming:     0
        ;   Readable:       1
        ;   Accessed:       0
        ; 2nd Flags:        0b1100
        ;   Granularity:    1
        ;   32-bit Default: 1
        ;   64-bit Segment: 0
        ;   AVL:            0
        dw 0xFFFF     ; Limit, bits 0 to 15
        dw 0x0000     ; Base, bits 0 to 15
        db 0x00       ; Base, bits 16 to 23
        db 0b10011010 ; 1st flags, type flags
        db 0b11001111 ; 2nd flags, limit, bits 16 to 19
        db 0x00       ; Base, bits 24 to 31