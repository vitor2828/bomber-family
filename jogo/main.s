.data

CHAR_POS:		.half 16,16 # posicao do personagem
OLD_CHAR_POS: 		.half 16,16 # redesenha os tiles para o personagem sumir
BOMB_POS:		.half 320, 320 # posicao da bomba
BOMB_TIMER:		.word 0 # timer para começar a explosao da bomba
EXPLOSION_TIMER:	.word 0 # timer para terminar a explosao da bomba

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
# s1 -> flag das bombas
# s2 -> salva o ra para funções internas

SET_LEVEL_1: # prepara o mapa da primeira fase (versao beta)

	li s1, 0
	la a0, BOMB_TIMER
	sw zero, 0(a0)
	
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
	
	la t0, CHAR_POS
	
	la a0, char
	lh a1, 0(t0)
	lh a2, 2(t0)
	li a3, 0
	mv a3, s0
	call PRINT
	
	
	li t0, 0xFF200604
	sw s0, 0(t0)
	
	la t0, OLD_CHAR_POS
	
	la a0, tile
	lh a1, 0(t0)
	lh a2, 2(t0)
	
	mv a3, s0
	xori a3, a3, 1
	call PRINT
	
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
	
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 0(t0)
	addi t1, t1, -16
	sh t1, 0(t0)
	ret
	
CHAR_RIGHT:

	la t0, CHAR_POS
	
	mv t6, ra
	jal CHECK_RIGHT
	mv ra, t6
	ret
	
CONFIRM_RIGHT:

	
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 0(t0)
	addi t1, t1, 16
	sh t1, 0(t0)
	ret

CHAR_UP:

	la t0, CHAR_POS

	mv t6, ra
	jal CHECK_UP
	mv ra, t6
	ret
	
CONFIRM_UP:
	
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, -16
	sh t1, 2(t0)
	ret
	
CHAR_DOWN:

	la t0, CHAR_POS
	
	mv t6, ra
	jal CHECK_DOWN
	mv ra, t6
	ret
	
CONFIRM_DOWN:

	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, 16
	sh t1, 2(t0)
	ret
	
DROP_BOMB:

	li t0, 1 # 1 = ja existe bomba
	beq s1, t0, DROP_BOMB_EXIT # se uma bomba ja estiver colocada, nao dropa a bomba
	
	li s1, 1 # fala que uma bomba existe
	
	la t0, CHAR_POS # pega o x e y do char 
	lh a1, 0(t0)
	lh a2, 2(t0)
	
	la t1, BOMB_POS # passa o x e y para a bomba
	sh a1, 0(t1)
	sh a2, 2(t1)
	
	la t0, BOMB_TIMER
	li a7, 30
	ecall
	sw a0, 0(t0)
	
	la a0, bomba # printa a bomba
	lh a1, 0(t1)
	lh a2, 2(t1)
	mv s2, ra
	call PRINT
	mv ra, s2
	
DROP_BOMB_EXIT:
	
	ret
	
UPDATE_BOMB:

	beq s1, zero, UPDATE_BOMB_EXIT # se nao existe bomba, nao precisa atualizar bomba
	
	la t0, BOMB_POS # pega a posicao da bomba
	
	li a7, 30
	ecall
	
	lh a1, 0(t0)
	lh a2, 2(t0)
	
	la t0, BOMB_TIMER
	lw t3, 0(t0)
	addi t3, t3, 2000
	
	bgt a0, t3, EXPLODE_BOMB
	
	la a0, bomba # printa a bomba de novo caso ela ainda exista
	mv s2, ra
	call PRINT
	mv ra, s2
	
	j UPDATE_BOMB_EXIT
	
EXPLODE_BOMB:

	la t0, BOMB_POS
	la t1, BOMB_TIMER
	lh a1, 0(t0)
	lh a2, 2(t0)

	la a0, tile
	mv s2, ra
	mv a3, s0
	call PRINT
	xori a3, a3, 1
	call PRINT
	mv ra, s2
	
	sw zero, 0(t1)
	
	la t0, EXPLOSION_TIMER
	li a7, 30
	ecall
	sw a0, 0(t0)
	
	li s1, 0

UPDATE_EXPLOSION:

	la t0, EXPLOSION_TIMER
	lw t1, 0(t0)
	beq t1, zero, UPDATE_EXPLOSION_EXIT
	
	li a7, 30
	ecall
	addi t1, t1, 500
	bge a0, t1, EXPLOSION_FINISHED
	
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	
	la a0, explosao
	mv a3, s0
	mv s2, ra
	call PRINT
	xori a3, a3, 1
	call PRINT
	mv ra, s2
	
	j UPDATE_EXPLOSION_EXIT
	
EXPLOSION_FINISHED:

	la t0, BOMB_POS
	la a0, tile
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	mv s2, ra
	call PRINT
	xori a3, a3, 1
	call PRINT
	mv ra, s2
	
	
	la t0, EXPLOSION_TIMER
	sw zero, 0(t0)
	
	
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
	
	
	
