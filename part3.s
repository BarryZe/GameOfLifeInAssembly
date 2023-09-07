.global _start
.equ pixel_buffer, 0xc8000000
.equ char_buffer, 0xc9000000
.equ ps2_address, 0xff200100
white: .word 0xffff
black: .word 0x00
colour: .word 0x0
check_colour_data: .word 0x0
GoLBoard:
	//  x 0 1 2 3 4 5 6 7 8 9 a b c d e f    y
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // 0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // 1
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 2
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 3
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 4
	.word 0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0 // 5
	.word 0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0 // 6
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 7
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 8
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 9
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // a
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // b
_start:
		mov sp, #0
		bl game
end:
        b       end
VGA_draw_point_ASM:
		push {lr,r4-r6}
		mov r4, #300//store 300 into r4
		add r4, r4, #20 // store 319 into r4
		cmp r0, r4//if x is larger than 319 end
		bgt end
		mov r5, #240//store 239 into r5
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
		pop {lr,r4-r6}
		bx lr
VGA_clear_pixelbuff_ASM:
		push {r0-r8, lr}
		ldr r4, =pixel_buffer
		mov r0, #0 //set x = 0
		mov r1, #0 //set y = 0
		ldr r2, white //0 is the color black
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
VGA_draw_line_ASM:
// takes (x1,y1), (x2,y2) to draw a colored line
	push {lr,r4,r0,r1,r2,r3}
	mov r4, r2		// r4 is x2
	ldr r2, colour		// r2 is color
	cmp r0, r4
	beq draw_vertical_line
	cmp r1, r3
	beq draw_horizontal_line
draw_horizontal_line:
    cmp r0, r4
	bgt exit_line
	bl VGA_draw_point_ASM
	add r0, r0, #1
	b draw_horizontal_line
draw_vertical_line:
	cmp r1, r3
	bgt exit_line
	bl VGA_draw_point_ASM
	add r1, r1,#1
	b draw_vertical_line
exit_line:
	pop {lr,r0-r4}
	bx lr
GoL_draw_grid_ASM:
	push {lr}
	mov r0, #0
	mov r1, #0
	mov r3, #240
	mov r2, #0
	bl VGA_draw_line_ASM
	mov r0, #20
	mov r1, #0
	mov r3, #240
	mov r2, #20
	bl VGA_draw_line_ASM
	mov r0, #40
	mov r1, #0
	mov r3, #240
	mov r2, #40
	bl VGA_draw_line_ASM
	mov r0, #60
	mov r1, #0
	mov r3, #240
	mov r2, #60
	bl VGA_draw_line_ASM
	mov r0, #80
	mov r1, #0
	mov r3, #240
	mov r2, #80
	bl VGA_draw_line_ASM
	mov r0, #100
	mov r1, #0
	mov r3, #240
	mov r2, #100
	bl VGA_draw_line_ASM
	mov r0, #120
	mov r1, #0
	mov r3, #240
	mov r2, #120
	bl VGA_draw_line_ASM
	mov r0, #140
	mov r1, #0
	mov r3, #240
	mov r2, #140
	bl VGA_draw_line_ASM
	mov r0, #160
	mov r1, #0
	mov r3, #240
	mov r2, #160
	bl VGA_draw_line_ASM
	mov r0, #180
	mov r1, #0
	mov r3, #240
	mov r2, #180
	bl VGA_draw_line_ASM
	mov r0, #200
	mov r1, #0
	mov r3, #240
	mov r2, #200
	bl VGA_draw_line_ASM
	mov r0, #220
	mov r1, #0
	mov r3, #240
	mov r2, #220
	bl VGA_draw_line_ASM
	mov r0, #240
	mov r1, #0
	mov r3, #240
	mov r2, #240
	bl VGA_draw_line_ASM
	mov r0, #260
	mov r1, #0
	mov r3, #240
	mov r2, #260
	bl VGA_draw_line_ASM
	mov r0, #280
	mov r1, #0
	mov r3, #240
	mov r2, #280
	bl VGA_draw_line_ASM
	mov r0, #300
	mov r1, #0
	mov r3, #240
	mov r2, #300
	bl VGA_draw_line_ASM
	mov r0, #300
	mov r1, #0
	mov r3, #240
	mov r2, #300
	add r0, #19
	add r2, #19
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #0
	mov r3, #0
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #20
	mov r3, #20
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #20
	mov r3, #20
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #40
	mov r3, #40
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #60
	mov r3, #60
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #80
	mov r3, #80
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #100
	mov r3, #100
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #120
	mov r3, #120
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #140
	mov r3, #140
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #160
	mov r3, #160
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #180
	mov r3, #180
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #200
	mov r3, #200
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #220
	mov r3, #220
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	mov r0, #0
	mov r1, #239
	mov r3, #239
	mov r2, #300
	add r2, r2, #20
	bl VGA_draw_line_ASM
	pop {lr}
	bx lr
VGA_draw_rect_ASM:
	push {lr, r4}
	sub r4, r2, #1 //r4 where is suppose to end
	mov r2, r0
	add r0, r0, #1
	add r2, r2, #1
	add r1, r1, #1
	sub r3, r3, #1
draw_rect_loop:
	cmp r0, r4
	bgt exit_draw_rect
	bl VGA_draw_line_ASM
	add r0, r0,#1
	add r2, r2, #1
	b draw_rect_loop
exit_draw_rect:
	pop {lr, r4}
	bx lr
GoL_fill_gridxy_ASM:
	push {lr, r4}
	mov r4, #20
	mul r0, r0, r4
	mul r1, r1, r4
	add r2, r0, r4
	add r3, r1, r4
	bl VGA_draw_rect_ASM
	pop {lr, r4}
	bx lr
GoL_draw_board_ASM:
	push {r4,r5,r6,r7,r8,r9,r10,lr}
	ldr r4, =GoLBoard
	mov r5, #0// counter
	mov r7, #16
draw_board_outer:
	cmp r5, #11
	bgt exit_board
	mov r6, #0
draw_board_inner:
	cmp r6, #15
	bgt draw_board_inner_To_outer
	b draw_board_inner_loop
draw_board_inner_To_outer:
	mov r6, #0
	add r5, r5, #1
	b draw_board_outer
draw_board_inner_loop:
	mul r8, r5, r7
	add r9, r8, r6
	ldr r10, [r4, r9, lsl #2]
	cmp r10, #0
	beq is_zero
	mov r0, r6
	mov r1, r5
	bl GoL_fill_gridxy_ASM
	add r6, r6, #1
	b draw_board_inner
is_zero:
	add r6, r6, #1
	b draw_board_inner
exit_board:
	pop {r4,r5,r6,r7,r8,r9,r10,lr}
	bx lr
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
		mov r3, r5
		mov r0, #1
		pop {r4-r6,lr}
		bx lr
game: 
	bl init
	mov r11,#0
	mov r12,#0
game_loop:
		bl read_PS2_data_ASM
		cmp r0, #0
		beq game_loop
		b key_is_not_zero
key_is_not_zero:
		cmp r3, #0xf0
		beq f0_detected
		cmp r3, #0x1c
		beq A_pressed
		cmp r3, #0x1b
		beq S_pressed
		cmp r3, #0x23
		beq	D_pressed
		cmp r3, #0x1d
		beq	W_pressed
		cmp r3, #0x29
		beq SPACE_pressed
		cmp r3, #0x31
		beq N_pressed
		b game_loop
SPACE_pressed:
	push {r0-r5}
	ldr r4, check_colour_data
	cmp r4, #0x0
	beq change_black_to_white
	ldr r5, =0xffff
	cmp r4, r5
	beq change_white_to_black
	pop {r0-r5}
	b update_cursor
change_black_to_white:
	mov r0, r11
	mov r1, r12
	ldr r2, =colour
	ldr r3, =0xffff
	str r3, [r2]
	bl GoL_fill_gridxy_ASM
	pop {r0-r5}
	b update_cursor
change_white_to_black:
	mov r0, r11
	mov r1, r12
	ldr r2, =colour
	mov r3, #0x0
	str r3, [r2]
	bl GoL_fill_gridxy_ASM
	pop {r0-r5}
	b update_cursor
exit_N_pressed:
	ldr r0, =colour
	ldr r1, =0x0
	str r1, [r0]
	bl VGA_clear_pixelbuff_ASM
	bl GoL_draw_grid_ASM
	bl GoL_draw_board_ASM
	b update_cursor
N_pressed:
	mov r5, #0
	mov r7, #16
	ldr r2, =GoLBoard
	mov r10, #1
	N_pressed_outer_loop:
	cmp r5, #11
	bgt exit_N_pressed
	mov r6, #0
N_pressed_inner_loop:
	cmp r6, #15
	bgt N_pressed_inner_to_outer
	mul r8, r5, r7
	add r9, r8, r6
	B check_rule
N_pressed_inner_to_outer:
	add r5, r5, #1
	b N_pressed_outer_loop
check_rule:
	mov r0, #0 //active neigbhors
check_rule_inner:
	push { r4,r5,r6,r7,r11,r12}
	cmp r6, #0
	beq check_rule_r6_is_zero
	cmp r6, #15
	beq check_rule_r6_is_fifteen
	cmp r5, #0
	beq check_rule_r5_is_zero
	cmp r5, #11
	beq check_rule_r5_is_eleven
	sub r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop {r4,r5,r6,r7,r11,r12}
	b n_found
active_neighbor_counter:
	push {lr}
	add r0, r0 ,#1
	pop {lr}
	bx lr
check_rule_r5_is_zero:
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop {r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_r5_is_eleven:
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop {r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_r6_is_zero:
	cmp r5, #0
	beq check_rule_topleft_corner
	cmp r5, #11
	beq check_rule_bottomleft_corner
	mov r11,r6
	sub r12,r5,#1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop {r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_topleft_corner:// finished need action
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop { r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_bottomleft_corner:
	add r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11,r6
	sub r12,r5,#1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	add r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop { r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_r6_is_fifteen:
	cmp r5, #0
	beq check_rule_topright_corner
	cmp r5, #11
	beq check_rule_bottomright_corner
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop { r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_topright_corner:
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	add r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop { r4,r5,r6,r7,r11,r12}
	b n_found
check_rule_bottomright_corner:
	sub r11, r6, #1
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	mov r11, r6
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	sub r11, r6, #1
	sub r12, r5, #1
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0x0
	bleq active_neighbor_counter
	pop { r4,r5,r6,r7,r11,r12}
	b n_found
n_found:
	mov r11, r6
	mov r12, r5
	bl check_colour
	ldr r4, check_colour_data
	cmp r4, #0
	beq box_is_active
	cmp r0,#3
	beq inactive_to_active
	add r6, r6, #1
	b N_pressed_inner_loop
inactive_to_active:
	mov r8, #1
	str r8, [r2, r9, lsl#2]
	add r6, r6, #1
	b N_pressed_inner_loop
box_is_active:
	cmp r0, #2
	blt active_to_inactive
	cmp r0, #3
	bgt active_to_inactive
	mov r8, #1
	str r8, [r2,r9, lsl #2]
	add r6, r6, #1
	b N_pressed_inner_loop
active_to_inactive:
	mov r8, #0
	str r8, [r2, r9, lsl#2]
	add r6, r6, #1
	b N_pressed_inner_loop
	
A_pressed:
	cmp r11, #0
	beq update_cursor
	bl empty_last
	sub r11, r11, #1
	b update_cursor
S_pressed: 
	cmp r12, #11
	beq update_cursor
	bl empty_last
	add r12, r12, #1
	b update_cursor
D_pressed:
	cmp r11, #15
	beq update_cursor
	bl empty_last
	add r11, r11, #1
	b update_cursor
W_pressed:
	cmp r12, #0
	beq update_cursor
	bl empty_last
	sub r12, r12, #1
	b update_cursor
check_colour:
	push {r4-r12,lr}
	mov r4, #20
	mov r5, #0
	mul r11, r11, r4
	mul r12, r12, r4
	add r11, r11, #10
	add r12, r12, #10
	ldr r6, =pixel_buffer
	lsl r11, r11, #1
	lsl r12, r12, #10
	add r11, r11, r12
	ldrh r12, [r6,r11]
	ldr r4, =check_colour_data
	str r12, [r4]
	pop {r4-r12,lr}
	bx lr
empty_last:
	push {lr,r4, r11, r12}
	mov r0, r11
	mov r1, r12
	ldr r4, check_colour_data
	cmp r4, #0x0
	beq it_was_black
	ldr r2, =colour
	ldr r3, =0xffff
	str r3, [r2]
	bl GoL_fill_gridxy_ASM
	pop {lr, r4,r11, r12}
	bx lr
it_was_black:
	ldr r2, =colour
	str r4, [r2]
	bl GoL_fill_gridxy_ASM
	pop {lr,r4,r11,r12}
	bx lr
update_cursor:
	mov r0, r11
	mov r1, r12
	bl check_colour
	ldr r2, =colour
	ldr r3, =0x1f
	str r3, [r2]
	bl GoL_fill_gridxy_ASM
	ldr r2, =colour
	mov r3, #0x0
	str r3, [r2]
	bl GoL_draw_grid_ASM
	b game_loop
f0_detected:
	bl timer
	bl read_PS2_data_ASM
	b game_loop
timer:
	push {r10,lr}
 	mov r10, #300
timer_loop:
	cmp r10, #0
	beq exit_timer
	sub r10, #1
	b timer_loop
exit_timer:
	pop {r10,lr}
	bx lr
init:
	bl VGA_clear_pixelbuff_ASM
	bl GoL_draw_grid_ASM
	bl GoL_draw_board_ASM
	ldr r0, =colour
	mov r1,#0x1f
	str r1,[r0]
	mov r11,#0
	mov r12, #0
	b update_cursor