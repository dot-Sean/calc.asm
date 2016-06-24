section .data
	FEW_ARGS: db "To Few Arguments", 0xA
	INVALID_OPERATOR: db "Invalid Operator", 0xA
	INVALID_OPERAND: db "Invalid Operand", 0XA
	BYTE_BUFFER: times 10 db 0

section .text

	global _start

_start:
	pop rdx ;;remove argc
	cmp rdx, 4
	jne few_args
	add rsp, 8 ;;remove argv[0]
	pop rsi

	cmp byte[rsi], 0x23
        je multiplication
	cmp byte[rsi], 0x2B
	je addition
	cmp byte[rsi], 0x2D
	je subtraction
	cmp byte[rsi], 0x2F
	je division

	jmp invalid_operator

addition:
	pop rsi
	call char_to_int
	mov r10, rax
	pop rsi
	call char_to_int
	add rax, r10
	jmp print_result

subtraction:
	pop rsi
	call char_to_int
	mov r10, rax
	pop rsi
	call char_to_int
	sub rax, r10
	jmp print_result

division:
	pop rsi
	call char_to_int
	mov r10, rax
	pop rsi
	call char_to_int
	mov rdx, 0
	div r10
	jmp print_result

multiplication:
	pop rsi
        call char_to_int
        mov r10, rax
        pop rsi
        call char_to_int
        


print_result:
	call int_to_char
	mov rax, 1
	mov rdi, 1
	mov rsi, r9
	mov rdx, 2
	syscall
	jmp exit
	
few_args:
	mov rax, 1
	mov rdi, 1
	mov rsi, FEW_ARGS
	mov rdx, 17
	syscall
	jmp exit

invalid_operator:
	mov rax, 1
	mov rdi, 1
	mov rsi, INVALID_OPERATOR
	mov rdx, 17
	syscall
	jmp exit

invalid_operand:
	mov rax, 1
	mov rdi, 1
	mov rsi, INVALID_OPERAND
	mov rdx, 16
	syscall
	jmp exit

char_to_int:
	xor al, al
	xor rbx, rbx
	xor cl, cl
	mov dl, 10
	
.loop_block:
	mov cl, [rsi]
	cmp cl, byte 0
	je .return_block
	sub cl, 48
	mul dl
	add al, cl
	inc bl
	inc rsi
	jmp .loop_block

.return_block:
	ret

int_to_char:
	mov rbx, 10
	mov r9, BYTE_BUFFER+10
	mov [r9], byte 0
	dec r9
	mov [r9], byte 0XA
	dec r9 

.loop_block:
	mov rdx, 0
	div rbx
	cmp rax, 0
        je .return_block
        add dl, 48
        mov [r9], dl
        dec r9
        jmp .loop_block
	
.return_block:
	add dl, 48
	mov [r9], dl
	dec r9
	ret

exit:
	mov rax, 60
	mov rdi, 0
	syscall



	
