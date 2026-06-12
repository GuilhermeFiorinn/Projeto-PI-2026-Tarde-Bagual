extends Node2D

enum State { PARADO, ESPERANDO_PEIXE, FISGADA, GANHOU, PERDEU, FIM_DO_JOGO }
var estado_atual = State.PARADO

var peixes_necessarios = 3
var peixes_pegos = 0

var posicao_inicial_rio: Vector2

@onready var botao = $ActionButton
@onready var texto_status = $StatusLabel
@onready var timer_espera = $FishingTimer
@onready var timer_qte = $QTE_Timer

# Seus dois sprites conectados
@onready var img_parado = $Sprite1cena
@onready var img_esticado = $Sprite2cena

# O seu splash de água
@onready var splash = $CPUParticles2D

func _ready() -> void:
	peixes_pegos = 0
	if img_esticado:
		posicao_inicial_rio = img_esticado.position
	
	if splash:
		splash.emitting = false
		splash.one_shot = true
		
	configurar_tela_inicial()

func _process(_delta: float) -> void:
	if estado_atual == State.ESPERANDO_PEIXE and img_esticado:
		img_esticado.position.y = posicao_inicial_rio.y + sin(Time.get_ticks_msec() * 0.005) * 5.0
	elif estado_atual == State.FISGADA and img_esticado:
		img_esticado.position.y = posicao_inicial_rio.y + 20.0

func configurar_tela_inicial():
	estado_atual = State.PARADO
	atualizar_texto_status("Toque no botão para lançar a isca!")
	botao.text = "LANÇAR VARA"
	botao.disabled = false
	
	if img_parado: img_parado.visible = true
	if img_esticado:
		img_esticado.position = posicao_inicial_rio
		img_esticado.visible = false

func atualizar_texto_status(mensagem: String):
	texto_status.text = mensagem + "\n(Peixes: " + str(peixes_pegos) + " de " + str(peixes_necessarios) + ")"

func _on_action_button_pressed() -> void:
	# 🏠 ROTA DE SAÍDA CORRIGIDA: Caminho exato para a sua cena Home.tscn
	if estado_atual == State.FIM_DO_JOGO or botao.text == "VOLTAR PARA A VILA":
		SceneController.change_scene("res://Scenes/Uis/Home.tscn")
		return

	if estado_atual == State.PARADO:
		estado_atual = State.ESPERANDO_PEIXE
		atualizar_texto_status("Aguardando o peixe... Relaxe...")
		botao.text = "---"
		botao.disabled = true
		
		if img_parado: img_parado.visible = false
		if img_esticado: img_esticado.visible = true
		
		if splash:
			splash.restart()
			splash.emitting = true
		
		timer_espera.wait_time = randf_range(3.0, 5.0)
		timer_espera.start()
		
	elif estado_atual == State.FISGADA:
		timer_qte.stop()
		peixes_pegos += 1
		
		if img_esticado: img_esticado.visible = false
		if img_parado: img_parado.visible = true
		
		if peixes_pegos >= peixes_necessarios:
			ganhou_tudo()
		else:
			proximo_peixe()
			
	elif estado_atual == State.GANHOU:
		configurar_tela_inicial()
			
	elif estado_atual == State.PERDEU:
		configurar_tela_inicial()

func _on_fishing_timer_timeout() -> void:
	estado_atual = State.FISGADA
	atualizar_texto_status("O PEIXE MORDEU! PUXA AGORA!")
	botao.text = "PUXAR!"
	botao.disabled = false
	
	timer_qte.wait_time = 3.5
	timer_qte.start()

func _on_qte_timer_timeout() -> void:
	estado_atual = State.PERDEU
	atualizar_texto_status("O peixe fugiu... Que pena!")
	botao.text = "TENTAR NOVAMENTE"
	botao.disabled = false

func proximo_peixe():
	estado_atual = State.GANHOU
	atualizar_texto_status("Você fisgou o peixe!")
	botao.text = "PESCAR PRÓXIMO"
	botao.disabled = false

func ganhou_tudo():
	estado_atual = State.FIM_DO_JOGO
	atualizar_texto_status("Parabéns! Você pescou todos os peixes!")
	botao.text = "VOLTAR PARA A VILA"
	botao.disabled = false
	
	GameController.task_list["fish"]["completed"] = true
