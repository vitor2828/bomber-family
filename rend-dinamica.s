# Código copiado do tutorial https://youtu.be/2BBPNgLP6_s?si=7cxnP3O85bZCaS7l
.data
CHAR_POS:	.half 0,0
OLD_CHAR_POS:	.half 0,0
.text

SETUP:

	la a0, map
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT
	
GAME_LOOP:

	call KEY2
	xori s0, s0, 1 # alterna entre 0 e 1 para configurar o frame
	 
	la t0, CHAR_POS

	la a0, char # carrega o endereco da imagem do personagem
	lh a1, 0(t0) # a1 recebe a posicao x do personagem
	lh a2, 2(t0) # a2 recebe a y
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
	
	j GAME_LOOP

#	a0 = endereco imagem
#	a1 = x
#	a2 = y
#	a3 = frame (0 ou 1) - a renderizacao dinamica exige alternancia entre o frame 0 e frame 1 do bitmap

#	t0 = endereco do bitmap display
#	t1 = endereco da imagem
#	t2 = contador de linha
#	t3 = contador de coluna
#	t4 = largura
#	t5 = altura

KEY2:

	li t1, 0xFF200000# carrega o endereco do KDMMIO
	lw t0, 0(t1)# le o bit de controle teclado
	andi t0, t0, 0x0001# mascara o bit menos significativo
	beq t0, zero, FIM # se nao ha tecla pressionada vai para FIM
	lw t2, 4(t1) # le o valor da tecla
	
	li t0, 'a'
	beq t2, t0, CHAR_LEFT # compara o valor da tecla com o 'a' do t0
	
	li t0, 'd'
	beq t2, t0, CHAR_RIGHT
	
	li t0, 'w'
	beq t2, t0, CHAR_UP
	
	li t0, 's'
	beq t2, t0, CHAR_DOWN
	
FIM:

	ret
	
CHAR_LEFT:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
## O old char pos faz a limpeza, para que nao haja rastro do char na tela
	
	lh t1, 0(t0)
	addi t1, t1, -16
	sh t1, 0(t0)
	ret
	
CHAR_RIGHT:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 0(t0)
	addi t1, t1, 16
	sh t1, 0(t0)
	ret
	
CHAR_UP:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, -16
	sh t1, 2(t0)
	ret
	
CHAR_DOWN:

	la t0, CHAR_POS
	la t1, OLD_CHAR_POS
	lw t2, 0(t0)
	sw t2, 0(t1)
	
	lh t1, 2(t0)
	addi t1, t1, 16
	sh t1, 2(t0)
	ret

PRINT:

	li t0, 0xFF0 # seta o endereco do frame 0 do bitmap
	add t0, t0, a3 # alterna entre os frames 0 e 1
	slli t0, t0, 20 # da um shift de 20 bits para a esquerda
	
	add t0, t0, a1 # adiciona a posicao x ao bitmap
	
	li t1, 320 
	mul t1, t1, a2
	add t0, t0, t1 # adiciona a posicao y ao bitmap
	
## Com isso, setamos o endereco do bitmap por completo

	addi t1, a0, 8 # recebe o inicio da informacao da imagem
	
	mv t2, zero 
	mv t3, zero
	
	lw t4, 0(a0)
	lw t5, 4(a0)
	
## Todos os registradores iniciais estão setados

PRINT_LINHA:

	lw t6, 0(t1)
	sw t6, 0(t0) # transferimos os pixeis da imagem para o bitmap display
	
	addi t0, t0, 4
	addi t1, t1, 4
	
	addi t3, t3, 4
	blt t3, t4, PRINT_LINHA
	
	addi t0, t0, 320 #desce a linha e volta pro inicio
	sub t0, t0, t4
	
	mv t3, zero
	addi t2, t2, 1
	bgt t5, t2, PRINT_LINHA
	
	
	ret
	

.data

.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
