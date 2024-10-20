[org 0x7C00]

jmp begin_real
kernel_size db 0

begin_real:
[bits 16]
; Initialises the base and stack pointer
mov bp, 0x0500
mov sp, bp

; Saves the ID of the boot drive, which is in DL.
mov byte[boot_drive], dl

; Prints a message
mov bx, hello_kernel
call print_BIOS

; Loads the next section
; The first sector has already been loaded, so we'll start
; with the second sector.
mov bx, 0x0002

; Loads sectors for the bootloader and the kernel.
; The number of sectors the kernel needs is in kernel_size.
; Since we made kernel_size be 0, we're gonna need 2 more.
mov cx, [kernel_size]
add cx, 2

; Stores the new sector straight after the first loaded one,
; at address 0x7E00. This'll help a fuck ton with jumping 
; between different sectors of the bootloader.
mov dx, 0x7E00

; We're good to load the new sectors now...
call load_BIOS
; ...and elevate our CPU to 32-bit mode
call elevate_BIOS

; An infinite loop in case we need one
bootsector_halt:
jmp $

; Feels weird including things midway through a file lol
%include "RealMode/print.asm"
%include "RealMode/elevate.asm"

; Data storage
hello_kernel: db "\nHello from the BIOS!\n", 0
boot_drive: db 0x00

; Pads the boot sector for the magic number
times 510 - ($ - $$) db 0x00
dw 0xAA55 ; The magic number



;============================;
; Start of the second sector ;
; Contains only 32-bit code  ;

bootsector_extended:
    begin_protected:
        [bits 32]

        ; Clears the VGA memory output
        call clear_prot

        ; Detects long mode. Will return if there's no error
        call detect_long_mode_prot

        ; Tests VGA-style print function
        mov esi, protected_alert
        call print_protected

        ; Initialises the page table
        call init_page_table_prot
        
        call elevate_protected

        jmp $ ; Another infinite loop

        ; Includes
        %include