[bits 16]
; Raises out CPU to 32-bit protected mode
elevate_BIOS:
    ; Disables interrupts since the CPU a bit
    ; crazy when elevating to 32-bit mode.
    cli

    ; Tells the CPU where the GDT is, since 
    ; 32-bit protected mode requires the GDT
    lgdt [gdt_32_descriptor]

    ; Enables 32-bit mode by setting bit 0
    ; of the original control register.
    ; We can't set it directly though, so we'll
    ; need to copy it's contents into EAX and back again.
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    ; Clears pipeline of 16-bit instructions with a far jump
    jmp code_seg:init_pm

    [bits 32]
    init_pm:
    ; We're in 32-bit mode now

    ; Tells all segment registers to point to our flatmode data segment
    mov ax, data_seg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Resets stack pointers since they got messed up in elevation
    mov ebp, 0x90000
    mov esp, ebp

    ; Jump to the second sector
    ; The code is in boot.asm
    jmp begin_protected