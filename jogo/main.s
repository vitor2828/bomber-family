.data

CHAR_POS:		.half 32,32 # posicao do personagem
BOMB_POS:		.half 0, 0 # posicao da bomba
ENEMY_1:		.word 1, 64, 128, 0, 0 # flag se o inimigo está vivo // posicao do inimigo // orientacao do inimigo
ENEMY_2:		.word 1, 512, 224, 2, 0
BOMB_TIMER:		.word 0 # timer para começar a explosao da bomba
EXPLOSION_TIMER:	.word 0 # timer para terminar a explosao da bomba
BOMB_FLAG:			.byte 0 #flag para a bomba
BOMB_SPRITE_COUNTER:	.byte 0
EXPLODE_BOMB_FLAG:	.byte 0
CHAR_LIVES:			.byte 3
PLAYER_SCORE:		.word 0
BOMB_POWER:			.byte 3
WIN_FLAG:			.byte 0


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
# s2/s7 -> salva o ra para funções internas
# s3 -> forca das bombas

SET_LEVEL_1: # prepara o mapa da primeira fase (versao beta)

	la a0, CHAR_LIVES
	lb a1, 0(a0)
	beq a1, zero, GAME_OVER

	la a0, BOMB_TIMER
	sw zero, 0(a0)

	la a0, ENEMY_1
	li a1, 1
	sw a1, 0(a0)
	li a1, 64
	sw a1, 4(a0)
	li a1, 128
	sw a1, 8(a0)

	la a0, ENEMY_2
	li a1, 1
	sw a1, 0(a0)
	li a1, 512
	sw a1, 4(a0)
	li a1, 224
	sw a1, 8(a0)
	li a1, 2
	sw a1, 12(a0)

	la a0, mapa_beta_tiled_c
	la a1, mapa_beta_tiled
	li a2, 75
	li a3, 0
	jal s7, RESTART_MAP

	la a0, BOMB_SPRITE_COUNTER
	lb zero, 0(a0)

	la a1, ENEMY_1
	li a7, 30
	ecall
	sw a0, 16(a1)

	la a1, ENEMY_2
	li a7, 30
	ecall
	sw a0, 16(a1)
	
	la a0, BOMB_FLAG
	sb zero, 0(a0)

	li a1, 0
	li a2, 0
	li a3, 0
	jal s7, PRINT_MAP
	li a3, 1
	jal s7, PRINT_MAP

	
GAME_LOOP_1: # game loop da primeira fase

	call KEYPOLL
	xori s0, s0, 1

	la a0, WIN_FLAG
	li a1, 1
	sb a1, 0(a0)
	
	jal UPDATE_BOMB
	jal UPDATE_EXPLOSION
	la s11, ENEMY_1
	la s10, enemy_beta
	jal UPDATE_ENEMY
	la s11, ENEMY_2
	la s10, enemy_beta
	jal UPDATE_ENEMY
	jal s7, MUSIC_LOOP

	la a0, WIN_FLAG
	lb a1, 0(a0)
	li a0, 1
	beq a1, a0, GAME_OVER

	mv a3, s0
	jal s7, PRINT_MAP

	la t0, CHAR_POS
	
	la a0, char
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call PRINT

	li t0, 0xFF200604
	sw s0, 0(t0)
		
#########LOOP DE DELAY##########
#	li a7,30
#	ecall
#	mv t0,a0
#	addi t0,t0,100
	

#LOOP_DELAY:

#	li a7,30
#	ecall
#	mv t1,a0
#	bgt t1,t0,FIM_DELAY
#	j LOOP_DELAY

#FIM_DELAY:

##########FUM DO LOOP###########

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
	addi t1, t1, -8
	sh t1, 0(t0)
	ret
	
CHAR_RIGHT:

	la t0, CHAR_POS
	
	mv t6, ra
	jal CHECK_RIGHT
	mv ra, t6
	ret
	
CONFIRM_RIGHT:

	lh t1, 0(t0)
	addi t1, t1, 8
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
	addi t1, t1, -8
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
	addi t1, t1, 8
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

	la a0, mapa_beta_tiled

	mv t1, a1
	mv t2, a2
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3
	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	li t5, 2
	sb t5, 0(a0)

	li t1, 32
	rem t2, a1, t1

	mv s2, ra

	beq t2, zero, FIX_Y_BOMB
	bge t2, t1, ADD_OFFSET_X
	blt t2, t1, SUB_OFFSET_X

FIX_Y_BOMB:

	la t0, CHAR_POS
	lh a2, 2(t0)
	li t1, 32

	rem t2, a2, t1
	li t1, 32

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

	li t1, 32
	sub t3, t1, t2
	add a1, a1, t3
	j FIX_Y_BOMB

SUB_OFFSET_X:

	sub a1, a1, t2
	j FIX_Y_BOMB

ADD_OFFSET_Y:

	li t1, 32
	sub t3, t1, t2
	add a2, a2, t3
	j CONTINUE_DROP_BOMB

SUB_OFFSET_Y:

	sub a2, a2, t2
	j CONTINUE_DROP_BOMB
	
UPDATE_BOMB:
    # Verifica se existe bomba ativa
    la t0, BOMB_FLAG
    lb t1, 0(t0)
    beq t1, zero, UPDATE_BOMB_EXIT

    # Obtém tempo atual
    li a7, 30
    ecall
    mv s1, a0          

    # Verifica se deve explodir
    la t0, BOMB_TIMER
    lw t2, 0(t0)         # t2 = tempo de colocação
    addi t3, t2, 2000    # t3 = tempo de explosão (2000ms)
    bge s1, t3, EXPLODE_BOMB

    sub t4, s1, t2       # t4 = tempo decorrido
    
    li t5, 125           # 250ms por frame (8 frames em 2000ms)
    div t4, t4, t5       # t4 = frame atual
    
    # Garante que está no range 0-7
    li t5, 8
	rem t4, t4, t5
    j STORE_FRAME
    

STORE_FRAME:
    la t0, BOMB_SPRITE_COUNTER
    sb t4, 0(t0)

    # Calcula endereço do sprite
    la a0, bomba
    lb t4, 0(t0)
    li t5, 1032          # Tamanho de cada sprite
    mul t5, t5, t4
    add a0, a0, t5       # a0 = sprite atual

    # Desenha bomba
    la t0, BOMB_POS
    lh a1, 0(t0)
    lh a2, 2(t0)
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
	lh a1, 0(t0)
	lh a2, 2(t0)

	la a0, mapa_beta_tiled

	mv t1, a1
	mv t2, a2
	li t3, 32
	li t4, 20

	div t1, t1, t3
	div t2, t2, t3
	mul t2, t2, t4
	add t1, t1, t2

	addi a0, a0, 8
	add a0, a0, t1

	li t5, 1
	sb t5 , 0(a0)

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
	jal s7, CHECK_DAMAGE
	la t0, ENEMY_1
	jal s7, CHECK_ENEMY_DAMAGE
	la t0, ENEMY_2
	jal s7, CHECK_ENEMY_DAMAGE

	la t0, BOMB_POWER
	lb s3, 0(t0)
	
	li a4, 0
	mv a3, s0
	
EXPLOSION_RIGHT:
	
	addi a1, a1, 32
	jal s7, CHECK_EXPLOSION_RIGHT
	call PRINT
	xori a3, a3, 1
	call PRINT
	jal s7, CHECK_DAMAGE
	la t0, ENEMY_1
	jal s7, CHECK_ENEMY_DAMAGE
	la t0, ENEMY_2
	jal s7, CHECK_ENEMY_DAMAGE
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_RIGHT
	j EXPLOSION_RIGHT
	
END_EXPLOSION_RIGHT:

	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	mv a3, s0

EXPLOSION_LEFT:
	
	addi a1, a1, -32
	jal s7, CHECK_EXPLOSION_LEFT
	call PRINT
	xori a3, a3, 1
	call PRINT
	jal s7, CHECK_DAMAGE
	la t0, ENEMY_1
	jal s7, CHECK_ENEMY_DAMAGE
	la t0, ENEMY_2
	jal s7, CHECK_ENEMY_DAMAGE
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_LEFT
	j EXPLOSION_LEFT
	
END_EXPLOSION_LEFT:
	
	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	mv a3, s0
	
EXPLOSION_UP:

	addi a2, a2, -32
	jal s7, CHECK_EXPLOSION_UP
	call PRINT
	xori a3, a3, 1
	call PRINT
	jal s7, CHECK_DAMAGE
	la t0, ENEMY_1
	jal s7, CHECK_ENEMY_DAMAGE
	la t0, ENEMY_2
	jal s7, CHECK_ENEMY_DAMAGE
	addi a4, a4, 1
	bge a4, s3, END_EXPLOSION_UP
	j EXPLOSION_UP
	
END_EXPLOSION_UP:

	li a4, 0
	la t1, BOMB_POS
	lh a1, 0(t1)
	lh a2, 2(t1)
	mv a3, s0
	
EXPLOSION_DOWN:
	
	addi a2, a2, 32
	jal s7, CHECK_EXPLOSION_DOWN
	call PRINT
	xori a3, a3, 1
	call PRINT
	jal s7, CHECK_DAMAGE
	la t0, ENEMY_1
	jal s7, CHECK_ENEMY_DAMAGE
	la t0, ENEMY_2
	jal s7, CHECK_ENEMY_DAMAGE
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

UPDATE_ENEMY:

	mv t0, s11
	lw a1, 0(t0)
	beq a1, zero, UPDATE_ENEMY_EXIT

	la a0, WIN_FLAG
	sb zero, 0(a0)


	mv a0, s10
	lw a1, 4(t0)
	lw a2, 8(t0)
	mv a3, s0
	mv s2, ra
	call PRINT
	xori a3, a3, 1
	call PRINT
	mv ra, s2

	mv t0, s11

	mv s2, ra
	lw t1, 4(t0)
	lw t2, 8(t0)
	call CHECK_DAMAGE_1
	mv ra, s2

	mv t0, s11
	lw t1, 16(t0)
	addi t1, t1, 50
	li a7, 30
	ecall
	bge a0, t1, CHECK_ENEMY_WALK

	j UPDATE_ENEMY_EXIT

CHECK_ENEMY_WALK:

	mv t0, s11
	lw t1, 4(t0)
	lw t2, 8(t0)
	lw t3, 12(t0)

	beq t3, zero, CHECK_ENEMY_RIGHT

RETURN_ENEMY_RIGHT:

	li t4, 1
	beq t3, t4, CHECK_ENEMY_UP

RETURN_ENEMY_UP:

	li t4, 2
	beq t3, t4, CHECK_ENEMY_LEFT

RETURN_ENEMY_LEFT:

	li t4, 3
	beq t3, t4, CHECK_ENEMY_DOWN

	j UPDATE_ENEMY_EXIT


WALK_ENEMY_RIGHT:

	mv t0, s11
	lw t1, 4(t0)
	addi t1, t1, 1
	sw t1, 4(t0)

	li a7, 30
	ecall

	sw a0, 16(t0)

	j UPDATE_ENEMY_EXIT

WALK_ENEMY_UP:

	mv t0, s11
	lw t2, 8(t0)
	addi t2, t2, -1
	sw t2, 8(t0)

	li a7, 30
	ecall

	sw a0, 16(t0)

	j UPDATE_ENEMY_EXIT

WALK_ENEMY_LEFT:

	mv t0, s11
	lw t1, 4(t0)
	addi t1, t1, -1
	sw t1, 4(t0)

	li a7, 30
	ecall

	sw a0, 16(t0)

	j UPDATE_ENEMY_EXIT

WALK_ENEMY_DOWN:

	mv t0, s11
	lw t2, 8(t0)
	addi t2, t2, 1
	sw t2, 8(t0)

	li a7, 30
	ecall

	sw a0, 16(t0)

	j UPDATE_ENEMY_EXIT


UPDATE_EXPLOSION_EXIT:

	ret
	
UPDATE_BOMB_EXIT:

	ret

UPDATE_ENEMY_EXIT:

	ret
	
	
PRINT: # seta o endereco do bitmap e ajusta os registradores de imagem

	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
	add t0, t0, a1
	li  t1, 640
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
	
	addi t0, t0, 640
	sub t0, t0, t4
	
	mv t3, zero
	addi t2, t2, 1
	bgt t5, t2, PRINT_LINHA
	
	ret

PRINT_MAP:
    la s8, mapa_beta_tiled
	addi s8, s8, 8  		# Endereço do mapa
    li s5, 0                # Contador de linhas (Y)

    # Configura dimensões
    li t3, 20               # Largura do mapa (colunas)
    li t4, 15               # Altura do mapa (linhas)

PRINT_MAP_LINE:
    li s4, 0                # Contador de colunas (X)

PRINT_MAP_COLUMN:
    # Carrega tile atual
    lb t1, 0(s8)

    # Calcula coordenadas (sem offsets)
    slli a1, s4, 5          # X = coluna * 16 (equivalente a mul por 16)
    slli a2, s5, 5         # Y = linha * 16


    # Seleciona tile baseado no valor
    beq t1, zero, PRINT_U_WALL    # Se tile == 0
    li t2, 1
    beq t1, t2, PRINT_TILE  # Se tile == 1
	li t2, 3
	beq t1, t2, PRINT_B_WALL

	j PRINT_TILE

PRINT_U_WALL:
    la a0, u_wall_tile_32
	slli a1, s4, 5
	slli a2, s5, 5
	call PRINT
	j NEXT_TILE
	

PRINT_TILE:
    la a0, tile_32
	slli a1, s4, 5
	slli a2, s5, 5
	call PRINT
	j NEXT_TILE

PRINT_B_WALL:
	la a0, b_wall
	slli a1, s4, 5
	slli a2, s5, 5
	call PRINT
	j NEXT_TILE

NEXT_TILE:
    # Avança para próximo tile
	li t3, 20
    addi s4, s4, 1          # Próxima coluna
    addi s8, s8, 1          # Próximo byte do mapa
    
    blt s4, t3, PRINT_MAP_COLUMN  # Continua na mesma linha

    # Próxima linha
	li t4, 15
    addi s5, s5, 1
    blt s5, t4, PRINT_MAP_LINE

	mv ra, s7

    ret

RESTART_MAP:

	lw t0, 0(a0)
	sw t0, 0(a1)
	addi a3, a3, 1
	addi a0, a0, 4
	addi a1, a1, 4
	blt a3, a2, RESTART_MAP
	mv ra, s7
	ret

GAME_OVER:

	li a7, 10
	ecall

.data

.include "sprites/mapa_beta.data"
.include "sprites/char.data"
.include "sprites/tile_32.data"
.include "sprites/u_wall_tile_32.data"
.include "hitbox.s"
.include "sprites/b_wall.s"
.include "musica.s"
.include "sprites/mapa_beta_tiled.data"
.include "sprites/mapa_beta_tiled_c.data"
.include "bomba.s"
.include "sprites/explosao.data"
.include "sprites/enemy_beta.data"
		
