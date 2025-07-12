##############
# 0 - paredes
# 1 - chao mod 1
# 2 - tile temporária da bomba
# 3 - tile parede destrutível
# 4 - chao mod 2
# 5 - fundo hud
# 6 - rosto personagem
# 7 - chao mod 3

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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	li t2, 3
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
	beq t1, zero, END_EXPLOSION_RIGHT
	li t2, 3
	beq t1, t2, DESTROY_BLOCK_RIGHT
	li t2, 4
	beq t1, t2, DESTROY_BLOCK_RIGHT

	la a0, explosao
	
	mv ra, s7
	ret

DESTROY_BLOCK_RIGHT:

	li t2, 4
	sb t2, 0(a0)
	la a0, explosao
	call PRINT
	xori a3, a3, 1
	call PRINT
	j END_EXPLOSION_RIGHT



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
	beq t1, zero, END_EXPLOSION_LEFT
	li t2, 3
	beq t1, t2, DESTROY_BLOCK_LEFT
	li t2, 4
	beq t1, t2, DESTROY_BLOCK_LEFT

	la a0, explosao
	mv ra, s7
	ret

DESTROY_BLOCK_LEFT:

	li t2, 4
	sb t2, 0(a0)
	la a0, explosao
	call PRINT
	xori a3, a3, 1
	call PRINT
	j END_EXPLOSION_LEFT

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
	beq t1, zero, END_EXPLOSION_UP
	li t2, 3
	beq t1, t2, DESTROY_BLOCK_UP
	li t2, 4
	beq t1, t2, DESTROY_BLOCK_UP

	la a0, explosao
	mv ra, s7
	ret

DESTROY_BLOCK_UP:

	li t2, 4
	sb t2, 0(a0)
	la a0, explosao
	call PRINT
	xori a3, a3, 1
	call PRINT
	j END_EXPLOSION_UP


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
	beq t1, zero, END_EXPLOSION_DOWN
	li t2, 3
	beq t1, t2, DESTROY_BLOCK_DOWN
	li t2, 4
	beq t1, t2, DESTROY_BLOCK_DOWN

	la a0, explosao
	mv ra, s7
	ret

DESTROY_BLOCK_DOWN:

	li t2, 4
	sb t2, 0(a0)
	la a0, explosao
	call PRINT
	xori a3, a3, 1
	call PRINT
	j END_EXPLOSION_DOWN

CHECK_DAMAGE:

	la t0, CHAR_POS
	lh t1, 0(t0)
	lh t2, 2(t0)

	li t3, 32
	rem t3, t1, t3

	beq t3, zero, FIX_Y_CHAR
	li t4, 16
	bgt t3, t4, ADD_OFFSET_X_CHAR
	ble t3, t4, SUB_OFFSET_X_CHAR

FIX_Y_CHAR:

	li t3, 32
	rem t3, t2, t3

	beq t3, zero, CHECK_COORDS_X
	li t4, 16
	bge t3, t4, ADD_OFFSET_Y_CHAR
	blt t3, t4, SUB_OFFSET_Y_CHAR

ADD_OFFSET_X_CHAR:

	li t4, 32
	sub t6, t4, t3
	add t1, t1, t6
	j FIX_Y_CHAR

SUB_OFFSET_X_CHAR:

	sub t1, t1, t3
	j FIX_Y_CHAR

ADD_OFFSET_Y_CHAR:

	li t4, 32
	sub t6, t4, t3
	add t2, t2, t6
	j CHECK_COORDS_X

SUB_OFFSET_Y_CHAR:

	sub t2, t2, t3
	j CHECK_COORDS_X

CHECK_COORDS_X:

	beq t1, a1, CHECK_COORDS_Y
	mv ra, s7
	ret

CHECK_COORDS_Y:

	beq t2, a2, KILL_CHAR
	mv ra, s7
	ret

KILL_CHAR:

	la t0, CHAR_LIVES
	lb t1, 0(t0)
	addi t1, t1, -1
	la a0, CHAR_POS
	li a1, 32
	sh a1, 0(a0)
	sh a1, 2(a0)
	li a7, 32
	li a0, 2000
	ecall
	sb t1, 0(t0)
	j SET_LEVEL_1

CHECK_ENEMY_RIGHT:

	la a0, mapa_beta_tiled
	addi t1, t1, 32
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	add a0, a0, t1
	addi a0, a0, 8

	lb t1, 0(a0)

	beq t1, zero, CHANGE_ORIENTATION_RIGHT_UP
	li t2, 2
	beq t1, t2, CHANGE_ORIENTATION_RIGHT_UP
	j WALK_ENEMY_RIGHT

CHANGE_ORIENTATION_RIGHT_UP:

	la a0, ENEMY_1
	lh a1, 6(a0)
	addi a1, a1, 1
	sh a1, 6(a0)
	j RETURN_ENEMY_RIGHT

CHECK_ENEMY_UP:

	la a0, mapa_beta_tiled
	addi t2, t2, -1
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	add a0, a0, t1
	addi a0, a0, 8

	lb t1, 0(a0)

	beq t1, zero, CHANGE_ORIENTATION_UP_LEFT
	li t2, 2
	beq t1, t2, CHANGE_ORIENTATION_UP_LEFT
	j WALK_ENEMY_UP

CHANGE_ORIENTATION_UP_LEFT:

	la a0, ENEMY_1
	lh a1, 6(a0)
	addi a1, a1, 1
	sh a1, 6(a0)
	j RETURN_ENEMY_UP

CHECK_ENEMY_LEFT:

	la a0, mapa_beta_tiled
	addi t1, t1, -1
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	add a0, a0, t1
	addi a0, a0, 8

	lb t1, 0(a0)

	beq t1, zero, CHANGE_ORIENTATION_LEFT_DOWN
	li t2, 2
	beq t1, t2, CHANGE_ORIENTATION_LEFT_DOWN
	j WALK_ENEMY_LEFT

CHANGE_ORIENTATION_LEFT_DOWN:

	la a0, ENEMY_1
	lh a1, 6(a0)
	addi a1, a1, 1
	sh a1, 6(a0)
	j RETURN_ENEMY_LEFT

CHECK_ENEMY_DOWN:

	la a0, mapa_beta_tiled
	addi t2, t2, 32
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3

	mul t2, t2, t4
	add t1, t1, t2

	add a0, a0, t1
	addi a0, a0, 8

	lb t1, 0(a0)

	beq t1, zero, RESTART_ORIENTATION
	li t2, 2
	beq t1, t2, RESTART_ORIENTATION
	j WALK_ENEMY_DOWN

RESTART_ORIENTATION:

	la a0, ENEMY_1
	sw zero, 6(a0)
	j UPDATE_ENEMY_EXIT

CHECK_ENEMY_DAMAGE:

	lh t1, 2(t0)
	lh t2, 4(t0)

	li t3, 32
	rem t3, t1, t3

	beq t3, zero, FIX_Y_ENEMY
	li t4, 16
	bgt t3, t4, ADD_OFFSET_X_ENEMY
	ble t3, t4, SUB_OFFSET_X_ENEMY

FIX_Y_ENEMY:

	li t3, 32
	rem t3, t2, t3

	beq t3, zero, CHECK_COORDS_X_ENEMY
	li t4, 16
	bge t3, t4, ADD_OFFSET_Y_ENEMY
	blt t3, t4, SUB_OFFSET_Y_ENEMY

ADD_OFFSET_X_ENEMY:

	li t4, 32
	sub t6, t4, t3
	add t1, t1, t6
	j FIX_Y_ENEMY

SUB_OFFSET_X_ENEMY:

	sub t1, t1, t3
	j FIX_Y_ENEMY

ADD_OFFSET_Y_ENEMY:

	li t4, 32
	sub t6, t4, t3
	add t2, t2, t6
	j CHECK_COORDS_X_ENEMY

SUB_OFFSET_Y_ENEMY:

	sub t2, t2, t3
	j CHECK_COORDS_X_ENEMY

CHECK_COORDS_X_ENEMY:

	beq t1, a1, CHECK_COORDS_Y_ENEMY
	mv ra, s7
	ret

CHECK_COORDS_Y_ENEMY:

	beq t2, a2, KILL_ENEMY
	mv ra, s7
	ret

KILL_ENEMY:

	sh zero, 0(t0)
	mv ra, s7
	ret

CHECK_DAMAGE_1: # a1 = x enemy // a2 = y

	la t0, CHAR_POS
	lh t3, 0(t0)
	lh t4, 2(t0)
	addi t5, t1, -16
	addi t6, t1, 16

CHECK_COORDS_X_1:

	bge t3, t5, CHECK_COORDS_X_2
	ret

CHECK_COORDS_X_2:

	ble t3, t6, CHECK_COORDS_Y_1
	ret

CHECK_COORDS_Y_1:

	addi t5, t2, -16
	addi t6, t2, 16
	bge t4, t5, CHECK_COORDS_Y_2
	ret	

CHECK_COORDS_Y_2:

	ble t4, t6, KILL_CHAR
	ret













	
	
