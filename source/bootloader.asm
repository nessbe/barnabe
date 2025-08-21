; File:        bootloader.asm
; Project:     sosos
; Repository:  https://github.com/nessbe/sosos
;
; Copyright (c) 2025 nessbe
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at:
;
;     https://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;
; For more details, see the LICENSE file at the root of the project.

[org 0x7c00] ; Boot sector starts at 0x7c00

_start:
	cli ; Disable interrupts

	; Clear the BSS segment
	xor ax, ax ; Clear AX
	mov ds,	ax ; Set DS to 0
	mov es, ax ; Set ES to 0
	mov ss, ax ; Set SS to 0

	mov sp, 0x7c00 ; Set stack pointer to the top of the boot sector

	mov si, print_message ; Load the address of the message into SI

print_loop:
	lodsb ; Load byte from DS:SI into AL
	cmp al, 0 ; Check for null terminator
	je done ; If null, jump to done

	mov ah, 0x0E ; BIOS teletype output function
	int 0x10 ; Call BIOS interrupt to print character in AL
	jmp print_loop ; Repeat for next character

done:
	hlt ; Halt the CPU

print_message db 'Hello, World!', 0 ; Null-terminated string

times 510 - ($ - $$) db 0 ; Fill the rest of the boot sector with zeros

dw 0xAA55 ; Boot sector signature (must be at the end of the boot sector)
