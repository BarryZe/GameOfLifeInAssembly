.global _start
.equ pixel_buffer, 0xc8000000
.equ char_buffer, 0xc9000000
_start:
        bl      draw_test_screen
end:
        b       end
@ TODO: Insert VGA driver functions here.
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
draw_test_screen:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r6, #0
        ldr     r10, .draw_test_screen_L8
        ldr     r9, .draw_test_screen_L8+4
        ldr     r8, .draw_test_screen_L8+8
        b       .draw_test_screen_L2
.draw_test_screen_L7:
        add     r6, r6, #1
        cmp     r6, #320
        beq     .draw_test_screen_L4
.draw_test_screen_L2:
        smull   r3, r7, r10, r6
        asr     r3, r6, #31
        rsb     r7, r3, r7, asr #2
        lsl     r7, r7, #5
        lsl     r5, r6, #5
        mov     r4, #0
.draw_test_screen_L3:
        smull   r3, r2, r9, r5
        add     r3, r2, r5
        asr     r2, r5, #31
        rsb     r2, r2, r3, asr #9
        orr     r2, r7, r2, lsl #11
        lsl     r3, r4, #5
        smull   r0, r1, r8, r3
        add     r1, r1, r3
        asr     r3, r3, #31
        rsb     r3, r3, r1, asr #7
        orr     r2, r2, r3
        mov     r1, r4
        mov     r0, r6
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        add     r5, r5, #32
        cmp     r4, #240
        bne     .draw_test_screen_L3
        b       .draw_test_screen_L7
.draw_test_screen_L4:
        mov     r2, #72
        mov     r1, #5
        mov     r0, #20
        bl      VGA_write_char_ASM
        mov     r2, #101
        mov     r1, #5
        mov     r0, #21
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #22
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #23
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #24
        bl      VGA_write_char_ASM
        mov     r2, #32
        mov     r1, #5
        mov     r0, #25
        bl      VGA_write_char_ASM
        mov     r2, #87
        mov     r1, #5
        mov     r0, #26
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #27
        bl      VGA_write_char_ASM
        mov     r2, #114
        mov     r1, #5
        mov     r0, #28
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #29
        bl      VGA_write_char_ASM
        mov     r2, #100
        mov     r1, #5
        mov     r0, #30
        bl      VGA_write_char_ASM
        mov     r2, #33
        mov     r1, #5
        mov     r0, #31
        bl      VGA_write_char_ASM
        pop     {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
        .word   1717986919
        .word   -368140053
        .word   -2004318071