##############
# 0 - paredes
# 1 - chao

.text


CHECK_LEFT:
	
	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	addi t1, t1, 24
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 7
	add a0, a0, t1
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE

	lh t2, 2(t0)
	rem t1, t2, t3
	beq t1, zero, CONFIRM_LEFT


	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	addi t1, t1, 24
	addi t2, t2, 32

	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 7
	add a0, a0, t1

	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE
	
	j CONFIRM_LEFT

CHECK_RIGHT:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 9
	add a0, a0, t1
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE


	lh t2, 2(t0)
	rem t1, t2, t3
	beq t1, zero, CONFIRM_RIGHT

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)

	addi t2, t2, 32

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 9
	add a0, a0, t1

	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE

	j CONFIRM_RIGHT
	
CHECK_UP:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	addi t2, t2, 24
	li t3, 32
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
	li t2, 2
	beq t1, t2, NO_MOVE

	lh t2, 0(t0)
	rem t1, t2, t3
	beq t1, zero, CONFIRM_UP

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	addi t2, t2, 24

	addi t1, t1, 32

	div t1, t1, t3
	div t2, t2, t3
	
	mul t2, t2, t4
	add t1, t1, t2
	
	addi a0, a0, 8
	add a0, a0, t1
	addi a0, a0, -20
	
	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE

	j CONFIRM_UP
	
CHECK_DOWN:

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)
	li t3, 32
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
	li t2, 2
	beq t1, t2, NO_MOVE

	lh t2, 0(t0)
	rem t1, t2, t3
	beq t1, zero, CONFIRM_DOWN

	la a0, mapa_beta_tiled
	lh t1, 0(t0)
	lh t2, 2(t0)

	addi t1, t1, 32

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	addi a0, a0, 20
	add a0, a0, t1

	lb t1, 0(a0)
	beq t1, zero, NO_MOVE
	li t2, 2
	beq t1, t2, NO_MOVE

	j CONFIRM_DOWN
	
NO_MOVE:
	ret

CHECK_EXPLOSION_RIGHT:

	la a0, mapa_beta_tiled
	li t3, 32
	li t4, 20

	div t1, a1, t3
	div t2, a2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	lb t1, 0(a0)
	la a0, explosao
	beq t1, zero, END_EXPLOSION_RIGHT

	mv ra, s7
	ret

CHECK_EXPLOSION_LEFT:

	la a0, mapa_beta_tiled
	li t3, 32
	li t4, 20

	div t1, a1, t3
	div t2, a2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	lb t1, 0(a0)
	la a0, explosao
	beq t1, zero, END_EXPLOSION_LEFT

	mv ra, s7
	ret

CHECK_EXPLOSION_UP:

	la a0, mapa_beta_tiled
	li t3, 32
	li t4, 20

	div t1, a1, t3
	div t2, a2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	lb t1, 0(a0)
	la a0, explosao
	beq t1, zero, END_EXPLOSION_UP

	mv ra, s7
	ret

CHECK_EXPLOSION_DOWN:

	la a0, mapa_beta_tiled
	li t3, 32
	li t4, 20

	div t1, a1, t3
	div t2, a2, t3

	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	lb t1, 0(a0)
	la a0, explosao
	beq t1, zero, END_EXPLOSION_DOWN

	mv ra, s7
	ret
	
	
