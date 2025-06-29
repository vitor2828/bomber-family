.data

CHAR_POS:		.half 16,16 # posicao do personagem
BOMB_POS:		.half 320, 320 # posicao da bomba
BOMB_TIMER:		.word 0 # timer para começar a explosao da bomba
EXPLOSION_TIMER:	.word 0 # timer para terminar a explosao da bomba
BOMB_FLAG:			.byte 0 #flag para a bomba
EXPLODE_BOMB_FLAG:	.byte 0

.text

# a0 -> endereco da imagem
# a1 -> x da imagem
# a2 -> y da imagem
# a3 -> frame mostrado no bitmap

# t0 -> endereco do bitmap
# t1 -> endereco da imagem
# t2 -> contador de linha
# t3 -> contador de coluna
# t4 -> altura
# t5 -> largura

## Obs: os registradores t podem assumir outros valores ao longo do código, desde que, posteriormente,
## voltem ao padrão

# s0 -> alterna entre os frames
# s1 -> 
# s2 -> salva o ra para funções internas
# s3 -> forca das bombas

SET_LEVEL_1: # prepara o mapa da primeira fase (versao beta)


	la a0, BOMB_TIMER
	sw zero, 0(a0)
	la a0, BOMB_FLAG
	sb zero, 0(a0)
	li s3, 3
	
	
	la a0, mapa_beta
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT

	
GAME_LOOP_1: # game loop da primeira fase

	call KEYPOLL
	xori s0, s0, 1
	
	jal UPDATE_BOMB
	jal UPDATE_EXPLOSION
	
	la a0, mapa_beta
	li a1, 0
	li a2, 0
	li a3, 0
	mv a3, s0
	call PRINT

	la t0, CHAR_POS
	
	la a0, char
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0
	mv a3, s0
	call PRINT

	li t0, 0xFF200604
	sw s0, 0(t0)
		
	j GAME_LOOP_1
	
KEYPOLL: #espera o usuario apertar algum botao e realiza uma acao

	li t1, 0xFF200000
	lw t0, 0(t1)
	andi t0, t0, 0x0001
	beq t0, zero, FIM
	lw t2, 4(t1)
	
	li t0, 'a'
	beq t2, t0, CHAR_LEFT
	
	li t0, 'w'
	beq t2, t0, CHAR_UP
	
	li t0, 's'
	beq t2, t0, CHAR_DOWN
	
	li t0, 'd'
	beq t2, t0, CHAR_RIGHT
	
	li t0, 'j'
	beq t2, t0, DROP_BOMB
		
FIM:

	ret
	
CHAR_LEFT:

	la t0, CHAR_POS
	
	mv t6, ra
	jal CHECK_LEFT
	mv ra, t6
	ret
	
CONFIRM_LEFT:
	
	lh t1, 0(t0)
	addi t1, t1, -4
	sh t1, 0(t0)
	ret
	
CHAR_RIGHT:

	la t0, CHAR_POS
	li t5, 2
	
	mv t6, ra
	jal CHECK_RIGHT
	mv ra, t6
	ret
	
CONFIRM_RIGHT:

	lh t1, 0(t0)
	addi t1, t1, 4
	sh t1, 0(t0)
	ret

CHAR_UP:

	la t0, CHAR_POS

	mv t6, ra
	jal CHECK_UP
	mv ra, t6
	ret
	
CONFIRM_UP:
	
	
	lh t1, 2(t0)
	addi t1, t1, -4
	sh t1, 2(t0)
	ret
	
CHAR_DOWN:

	la t0, CHAR_POS
	
	mv t6, ra
	jal CHECK_DOWN
	mv ra, t6
	ret
	
CONFIRM_DOWN:

	
	lh t1, 2(t0)
	addi t1, t1, 4
	sh t1, 2(t0)
	ret
	
DROP_BOMB:

	la t0, BOMB_FLAG
	lb t1, 0(t0)
	li t2, 1 # 1 = ja existe bomba
	beq t1, t2, DROP_BOMB_EXIT # se uma bomba ja estiver colocada, nao dropa a bomba
	
	sb t2, 0(t0) # fala que uma bomba existe
	
	la t0, CHAR_POS # pega o x e y do char 
	lh a1, 0(t0)
	lh a2, 2(t0)
	li t1, 16

	rem t2, a1, t1
	li t1, 8

	mv s2, ra

	beq t2, zero, FIX_Y_BOMB
	bge t2, t1, ADD_OFFSET_X
	blt t2, t1, SUB_OFFSET_X

FIX_Y_BOMB:

	la t0, CHAR_POS
	lh a2, 2(t0)
	li t1, 16

	rem t2, a2, t1
	li t1, 8

	beq t2, zero, CONTINUE_DROP_BOMB
	bge t2, t1, ADD_OFFSET_Y
	blt t2, t1, SUB_OFFSET_Y

CONTINUE_DROP_BOMB:
	
	la t1, BOMB_POS # passa o x e y para a bomba
	sh a1, 0(t1)
	sh a2, 2(t1)
	
	la t0, BOMB_TIMER
	li a7, 30 # syscall para pegar o tempo
	ecall
	sw a0, 0(t0) # seta o time em que a bomba foi colocada
	
	la a0, bomba # printa a bomba
	lh a1, 0(t1)
	lh a2, 2(t1)
	call PRINT
	mv ra, s2
	
DROP_BOMB_EXIT:
	
	ret

ADD_OFFSET_X:

	li t1, 16
	sub t3, t1, t2
	add a1, a1, t3
	j FIX_Y_BOMB

SUB_OFFSET_X:

	sub a1, a1, t2
	j FIX_Y_BOMB

ADD_OFFSET_Y:

	li t1, 16
	sub t3, t1, t2
	add a2, a2, t3
	j CONTINUE_DROP_BOMB

SUB_OFFSET_Y:

	sub a2, a2, t2
	j CONTINUE_DROP_BOMB
	
UPDATE_BOMB:

	la t1, BOMB_FLAG
	lb t2, 0(t1)
	beq t2, zero, UPDATE_BOMB_EXIT # se nao existe bomba, nao precisa atualizar bomba

	la t0, BOMB_POS # pega a posicao da bomba
	
	li a7, 30 # pega o tempo em que o loop ocorreu
	ecall
	
	lh a1, 0(t0)
	lh a2, 2(t0)
	
	la t0, BOMB_TIMER # pega o tempo inicial da bomba
	lw t3, 0(t0)
	addi t3, t3, 2000 # soma 2000 para pegar o tempo inicial da bomba + 2 segundos
	
	bgt a0, t3, EXPLODE_BOMB # se o time da bomba + 2 segundos for menor que o time do loop, a bomba explode
	
	la a0, bomba # printa a bomba de novo caso ela ainda exista
	mv s2, ra
	call PRINT
	mv ra, s2
	
	j UPDATE_BOMB_EXIT # sai da label para voltar ao gameloop

EXPLODE_BOMB:

	la t1, BOMB_FLAG
	lb t2, 0(t0)
	beq t2, zero, UPDATE_BOMB_EXIT

	la t1, EXPLODE_BOMB_FLAG
	lb t2, 0(t0)
	li t3, 1
	beq t2, t3, UPDATE_BOMB_EXIT

	la t0, BOMB_POS
	la t1, BOMB_TIMER
	lh a1, 0(t0)
	lh a2, 2(t0)

	la t0, EXPLOSION_TIMER
	li a7, 30
	ecall
	sw a0, 0(t0)

	la t0, BOMB_TIMER
	sw zero, 0(t0)

	la t0, EXPLODE_BOMB_FLAG
	li t1, 1
	sb t1, 0(t0)

UPDATE_EXPLOSION:

	la t0, EXPLOSION_TIMER 
	lw t1, 0(t0)
	beq t1, zero, UPDATE_EXPLOSION_EXIT # se o timer não estiver definido, não há bomba. Portanto, apenas volta para o gameloop
	
	li a7, 30
	ecall
	addi t1, t1, 500
	bge a0, t1, EXPLOSION_FINISHED # define o tempo de explosao na mesma lógica que a bomba

	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	
# adicionar um loop para printar o sprite da explosao nos 4 tiles adjacentes

	la a0, explosao # printa a explosao
	mv s2, ra
	mv a3, s0
	call PRINT
	xori a3, a3, 1
	call PRINT
	
	li a4, 0
	mv a3, s0
	
EXPLOSION_RIGHT:
	
	addi a1, a1, 16
	call PRINT
	xori a3, a3, 1
	call PRINT
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_RIGHT
	j EXPLOSION_RIGHT
	
END_EXPLOSION_RIGHT:

	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)

EXPLOSION_LEFT:
	
	addi a1, a1, -16
	call PRINT
	xori a3, a3, 1
	call PRINT
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_LEFT
	j EXPLOSION_LEFT
	
END_EXPLOSION_LEFT:
	
	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	
EXPLOSION_UP:

	addi a2, a2, -16
	call PRINT
	xori a3, a3, 1
	call PRINT
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_UP
	j EXPLOSION_UP
	
END_EXPLOSION_UP:

	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	
EXPLOSION_DOWN:
	
	addi a2, a2, 16
	call PRINT
	xori a3, a3, 1
	call PRINT
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_DOWN
	j EXPLOSION_DOWN
	
END_EXPLOSION_DOWN:
	
	mv ra, s2
	
	j UPDATE_EXPLOSION_EXIT
	
EXPLOSION_FINISHED:
	
	la t0, EXPLOSION_TIMER # reseta o timer da explosao
	sw zero, 0(t0)
	
	la t1, BOMB_FLAG
	sb zero, 0(t1)

	la t2, EXPLODE_BOMB_FLAG
	sb zero, 0(t2)
	
UPDATE_EXPLOSION_EXIT:

	ret
	
UPDATE_BOMB_EXIT:

	ret
	
	

PRINT: # seta o endereco do bitmap e ajusta os registradores de imagem

	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
	add t0, t0, a1
	li t1, 320
	mul t1, t1, a2
	add t0, t0, t1
	
	addi t1, a0, 8
	
	mv t2, zero
	mv t3, zero
	
	lw t4, 0(a0)
	lw t5, 4(a0)
	
PRINT_LINHA: #loop que printa tinha por linha até o fim da imagem

	lw t6, 0(t1)
	sw t6, 0(t0)
	
	addi t0, t0, 4
	addi t1, t1, 4
	
	addi t3, t3, 4
	blt t3, t4, PRINT_LINHA
	
	addi t0, t0, 320
	sub t0, t0, t4
	
	mv t3, zero
	addi t2, t2, 1
	bgt t5, t2, PRINT_LINHA
	
	ret
	
.data

.include "sprites/mapa_beta.data"
.include "sprites/char.s"
.include "sprites/tile.data"
.include "hitbox.s"
.include "sprites/mapa_beta_tiled.data"
.include "sprites/bomba.data"
.include "sprites/explosao.data"
		
