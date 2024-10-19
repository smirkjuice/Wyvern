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

%include