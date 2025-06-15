.data

CHAR_POS:	.half 32,32
OLD_CHAR_POS: 	.half 32,32

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


SET_LEVEL_1: # prepara o mapa da primeira fase (versao beta)

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
		
FIM:

	ret
	
CHAR_LEFT:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lh t2, 0(t0)
	
	li t3, 20
	addi t4, t2, -16
	bge t4, t3, CONFIRM_LEFT
	ret
	
CONFIRM_LEFT:
	
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 0(t0)
	addi t1, t1, -16
	sh t1, 0(t0)
	ret
	
CHAR_RIGHT:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lh t2, 0(t0)
	
	li t3, 280
	addi t4, t2, 16
	ble t4, t3, CONFIRM_RIGHT
	ret
	
CONFIRM_RIGHT:
	
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 0(t0)
	addi t1, t1, 16
	sh t1, 0(t0)
	ret
	
CHAR_UP:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lh t2, 2(t0)
	
	li t3, 20
	addi t4, t2, -16
	bge t4, t3, CONFIRM_UP
	ret
	
CONFIRM_UP:
	
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, -16
	sh t1, 2(t0)
	ret
	
CHAR_DOWN:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lh t2, 2(t0)
	
	li t3, 200
	addi t4, t2, 16
	ble t4, t3, CONFIRM_DOWN
	ret
	
CONFIRM_DOWN:

	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, 16
	sh t1, 2(t0)
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
	
	
	

