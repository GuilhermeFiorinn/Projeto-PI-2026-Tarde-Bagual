extends MiniGameBase  # 👈 AGORA HERDA DA SUA CLASSE BASE

enum State { PARADO, ESPERANDO_PEIXE, FISGADA, GANHOU, PERDEU, FIM_DO_JOGO }
var estado_atual = State.PARADO

var posicao_inicial_player: Vector2
var posicao_inicial_peixe: Vector2

# 🟢 Recuo de 45 pixels para trás (X negativo) apenas para o sprite do idoso parado
var offset_idoso_parado: Vector2 = Vector2(45, 0) 

@onready var botao = $ButtonLeft
@onready var texto_status = $StatusLabel
@onready var timer_espera = $FishingTimer
@onready var timer_qte = $QTE_Timer
@onready var splash = $CPUParticles2D

# Nós visuais da cena
@onready var player = $Player
@onready var peixe1 = $Peixe1
@onready var peixe2 = $Peixe2
@onready var peixe3 = $Peixe3

# 🖼️ Caminhos das suas imagens
var img_player_parado = preload("res://Sprites/Player/idoso lado parado.png")
var img_player_pescando = preload("res://Sprites/Player/pescador_pescando.png")

var peixe_atual: Node2D = null

func _ready() -> void:
	# 👈 IMPORTANTE: Inicializa as metas da classe base antes de rodar o resto
	meta_acertos = 3  # Substitui o 'peixes_necessarios'
	limite_erros = 3  # Limite de vezes que o peixe pode fugir antes do Game Over
	
	super._ready() # Executa o _ready() da MiniGameBase (conecta botão voltar, etc)
	
	if player:
		posicao_inicial_player = player.position
	
	if peixe1:
		posicao_inicial_peixe = peixe1.position
	else:
		posicao_inicial_peixe = Vector2(360, 593)
	
	if splash:
		splash.emitting = false
		splash.one_shot = true
		
	configurar_tela_inicial()

func _process(_delta: float) -> void:
	if jogo_finalizado: return # Interrompe as animações caso o minijogo acabe
	
	# 1️⃣ ANIMAÇÃO AJUSTADA: Balanço do player super sutil
	if estado_atual == State.ESPERANDO_PEIXE and player:
		player.position.y = posicao_inicial_player.y + cos(Time.get_ticks_msec() * 0.004) * 0.8
		queue_redraw() 
	
	# 2️⃣ ANIMAÇÃO: Apenas o PEIXE se debate na água.
	if estado_atual == State.FISGADA and peixe_atual:
		var balanco_peixe = sin(Time.get_ticks_msec() * 0.03) * 20.0
		peixe_atual.position.y = posicao_inicial_peixe.y + balanco_peixe
		queue_redraw() 

func _draw() -> void:
	if estado_atual == State.ESPERANDO_PEIXE or estado_atual == State.FISGADA:
		if player:
			var ponta_da_vara = player.position + Vector2(-60, -40)
			
			var ponto_na_agua = posicao_inicial_peixe
			if peixe_atual and estado_atual == State.FISGADA:
				ponto_na_agua = peixe_atual.position 
			else:
				ponto_na_agua = Vector2(player.position.x - 220, posicao_inicial_peixe.y)
				
			draw_line(ponta_da_vara, ponto_na_agua, Color(1.0, 1.0, 1.0, 1.0), 3.5)

func configurar_tela_inicial():
	estado_atual = State.PARADO
	atualizar_texto_status("Toque no botão para lançar a isca!")
	
	if botao and "text" in botao:
		botao.text = "LANÇAR VARA"
		botao.disabled = false
	
	if player:
		player.position = posicao_inicial_player + offset_idoso_parado
		if img_player_parado: 
			player.texture = img_player_parado
	
	peixe_atual = null
	esconder_todos_os_peixes()
	queue_redraw()

func atualizar_texto_status(mensagem: String):
	if texto_status:
		texto_status.text = mensagem

func esconder_todos_os_peixes():
	if peixe1: peixe1.visible = false
	if peixe2: peixe2.visible = false
	if peixe3: peixe3.visible = false

func mostrar_peixe_atual_no_rio():
	# Baseado no score da classe base (acertos_atuais) 
	if acertos_atuais == 0: peixe_atual = peixe1
	elif acertos_atuais == 1: peixe_atual = peixe2
	elif acertos_atuais == 2: peixe_atual = peixe3
		
	if peixe_atual:
		peixe_atual.position = posicao_inicial_peixe
		peixe_atual.visible = true

func _on_action_button_pressed() -> void:
	if jogo_finalizado: return # Bloqueia interações se o jogo acabou 

	if estado_atual == State.PARADO:
		estado_atual = State.ESPERANDO_PEIXE
		atualizar_texto_status("Aguardando o peixe... Relaxe...")
		if botao and "text" in botao:
			botao.text = "---"
			botao.disabled = true
		
		if img_player_pescando: 
			player.texture = img_player_pescando
			if player:
				player.position = posicao_inicial_player 
		
		if splash:
			splash.restart()
			splash.emitting = true
		
		timer_espera.wait_time = randf_range(3.0, 5.0)
		timer_espera.start()
		queue_redraw()
		
	elif estado_atual == State.FISGADA:
		timer_qte.stop()
		
		# 🟢 ADAPTADO: Registra o acerto no gerenciador global 
		registrar_acerto()
		
		esconder_todos_os_peixes()
		peixe_atual = null
		queue_redraw()
		
		# Se a meta de acertos já foi batida, o MiniGameBase cuida do encerramento 
		if acertos_atuais >= meta_acertos:
			estado_atual = State.FIM_DO_JOGO
			atualizar_texto_status("Parabéns! Você pescou todos os peixes!")
			GameController.task_list["fish"]["completed"] = true # Salva no progresso [cite: 275]
		else:
			proximo_peixe()
			
	elif estado_atual == State.GANHOU or estado_atual == State.PERDEU:
		configurar_tela_inicial()

func _on_fishing_timer_timeout() -> void:
	estado_atual = State.FISGADA
	atualizar_texto_status("O PEIXE MORDEU! PUXA AGORA!")
	mostrar_peixe_atual_no_rio()
	
	if botao and "text" in botao:
		botao.text = "PUXAR!"
		botao.disabled = false
	
	timer_qte.wait_time = 3.5
	timer_qte.start()

func _on_qte_timer_timeout() -> void:
	# 🟢 ADAPTADO: Registra o erro no gerenciador global [cite: 2]
	registrar_erro()
	
	esconder_todos_os_peixes()
	peixe_atual = null
	queue_redraw()
	
	if erros_atuais >= limite_erros:
		estado_atual = State.FIM_DO_JOGO
		atualizar_texto_status("Fim de Jogo! Você perdeu muitos peixes.")
	else:
		estado_atual = State.PERDEU
		atualizar_texto_status("O peixe fugiu... Que pena!")
		if botao and "text" in botao:
			botao.text = "TENTAR NOVAMENTE"
			botao.disabled = false

func proximo_peixe():
	estado_atual = State.GANHOU
	atualizar_texto_status("Você fisgou o peixe!")
	if botao and "text" in botao:
		botao.text = "PESCAR PRÓXIMO"
		botao.disabled = false
