##############
# 0 - paredes
# 1 - chao

.text
.globl CHECK_LEFT, CHECK_RIGHT, CHECK_DOWN, CHECK_UP


CHECK_LEFT:
	
	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 16
	li t4, 20
	
	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 7
	add a0, a0, t1
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	j CONFIRM_LEFT

CHECK_RIGHT:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 16
	li t4, 20
	
	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 9
	add a0, a0, t1
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	j CONFIRM_RIGHT
	
CHECK_UP:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 16
	li t4, 20
	
	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	
	addi a0, a0, 8
	add a0, a0, t1
	addi a0, a0, -20
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	j CONFIRM_UP
	
CHECK_DOWN:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 16
	li t4, 20
	
	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 8
	addi a0, a0, 20
	add a0, a0, t1
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	j CONFIRM_DOWN
	
NO_MOVE:
	ret
	
	
