.data
# Limites de mapa
LEFT_WALL: 	.word 20
RIGHT_WALL:	.word 280
TOP_WALL:	.word 20
BOTTOM_WALL:	.word 200

# Blocos indestrutíveis internos

BLOCOS:		.word 64, 64, 144, 64, 224, 64, 64, 144, 144, 144, 224, 144	

.text
.globl CHECK_LEFT, CHECK_RIGHT, CHECK_DOWN, CHECK_UP

CHECK_LEFT:

	la t3, LEFT_WALL
	lw t4, 0(t3)
	addi t5, t2, -16
	mv t3, ra
	bge t4, t5, NO_MOVE
	j CONFIRM_LEFT
	
CHECK_RIGHT:

	la t3, RIGHT_WALL
	lw t4, 0(t3)
	addi t5, t2, 16
	mv t3, ra
	bge t5, t4, NO_MOVE
	j CONFIRM_RIGHT
	
CHECK_UP:

	la t3, TOP_WALL
	lw t4, 0(t3)
	addi t5, t2, -16
	mv t3, ra
	bge t4, t5, NO_MOVE
	j CONFIRM_UP
	
CHECK_DOWN:

	la t3, BOTTOM_WALL
	lw t4, 0(t3)
	addi t5, t2, 16
	mv t3, ra
	bge t5, t4, NO_MOVE
	j CONFIRM_DOWN
	
NO_MOVE:
	mv ra, t3
	ret
	
	
