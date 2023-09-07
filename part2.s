.global _start
.equ pixel_buffer, 0xc8000000
.equ char_buffer, 0xc9000000
.equ ps2_address, 0xff200100
_start:
        bl      input_loop
end:
        b       end

@ TODO: copy VGA driver here.
VGA_draw_point_ASM:
		push {r4-r6}
		mov r4, #300//store 300 into r4
		add r4, r4, #19 // store 319 into r4
		cmp r0, r4//if x is larger than 319 end
		bgt end
		mov r5, #239//store 239 into r5
		cmp r1, r5// if y is larger than 239 end
		bgt end
		cmp r0, #0
		blt end
		cmp r1, #0
		blt end
		ldr r6, =pixel_buffer
		mov r4, #2
		mov r5, #1024
		mul r4, r0, r4// shift 
		mul r5, r1, r5
		add r4, r4, r5
		add r6, r6, r4
		strh r2, [r6]
		pop {r4-r6}
		bx lr
VGA_clear_pixelbuff_ASM:
		push {r0-r8, lr}
		ldr r4, =pixel_buffer
		mov r0, #0 //set x = 0
		mov r1, #0 //set y = 0
		mov r2, #0 //0 is the color black
		mov r5, #300
		add r5, r5, #20
		B clear_pixel_inner_loop
clear_pixel_outer_loop:
		mov r0, #0
		add r1, r1, #1
		cmp r1, #240
		beq exit
		b clear_pixel_inner_loop
clear_pixel_inner_loop:
		cmp r0, r5
		beq clear_pixel_outer_loop
		bl VGA_draw_point_ASM
		add r0, r0, #1
		b clear_pixel_inner_loop
exit:
		pop {r0-r8,lr}
		BX lr
VGA_clear_charbuff_ASM:
		push {r0-r8, lr}
		ldr r4, =char_buffer
		mov r0, #0 //set x = 0
		mov r1, #0 //set y = 0
		mov r2, #0 //0 is the color black
		mov r5, #80
		B clear_char_inner_loop
clear_char_outer_loop:
		mov r0, #0
		add r1, r1, #1
		cmp r1, #60
		beq exit
		b clear_char_inner_loop
clear_char_inner_loop:
		cmp r0, r5
		beq clear_char_outer_loop
		bl VGA_write_char_ASM
		add r0, r0, #1
		b clear_char_inner_loop
VGA_write_char_ASM:
		push {r3-r5}
		cmp r0,#79
		bgt end
		cmp r1,#59
		bgt end
		cmp r0, #0
		blt end
		cmp r1, #0
		blt end
		mov r5, #128
		ldr r4, =char_buffer
		mul r3, r1, r5
		add r4, r4, r3
		add r4, r4, r0
		strb r2, [r4]
		pop {r3-r5}
		bx lr
@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
		push {r4-r6,lr}
		ldr r4, =ps2_address
		B check_ready
check_ready:
		
		ldr r5, [r4]
		LSR r6,r5, #15
		AND r6, r6, #1
		CMP r6, #1
		BEQ read
		mov r0, #0
		pop {r4-r6,lr}
		bx lr
read:
		and r5, r5,#0xff
		strb r5, [r0]
		mov r0, #1
		pop {r4-r6,lr}
		bx lr
write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}