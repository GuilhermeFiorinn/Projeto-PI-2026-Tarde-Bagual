extends Node2D
class_name MiniGameBase

@export var meta_acertos: int = 5
@export var limite_erros: int = 3

var acertos_atuais: int = 0
var erros_atuais: int = 0
var jogo_finalizado: bool = false

@onready var label_acertos = $ScoreUI/MarginContainer/VBoxContainer/LabelAcertos
@onready var label_erros = $ScoreUI/MarginContainer/VBoxContainer/LabelErros
@onready var som_vitoria = $ScoreUI/SomVitoria
@onready var som_erro = $ScoreUI/SomErro # 👈 Referência para o nó de áudio de erro 
@onready var botao_voltar = $ScoreUI/BotaoVoltar

func _ready() -> void:
	atualizar_ui()
	if botao_voltar:
		botao_voltar.pressed.connect(_on_botao_voltar_pressed)

func registrar_acerto() -> void:
	if jogo_finalizado: return
	acertos_atuais += 1
	atualizar_ui()
	
	# 🔊 Toca o som de acerto a cada acerto individual
	if som_vitoria:
		som_vitoria.play()
		
	if acertos_atuais >= meta_acertos:
		ganhou_minijogo()

func registrar_erro() -> void:
	if jogo_finalizado: return
	erros_atuais += 1
	atualizar_ui()
	
	# 🔊 Toca o som de erro a cada erro individual
	if som_erro:
		som_erro.play()
		
	if erros_atuais >= limite_erros:
		perdeu_minijogo()

func atualizar_ui() -> void:
	if label_acertos:
		label_acertos.text = "ACERTOS: " + str(acertos_atuais) + "/" + str(meta_acertos)
	if label_erros:
		label_erros.text = "ERROS: " + str(erros_atuais) + "/" + str(limite_erros)

# VITÓRIA GENERALIZADA PARA TODOS OS JOGOS
func ganhou_minijogo() -> void:
	jogo_finalizado = true
	congelar_minijogo()
	
	# Toca o som de vitória se ele existir 
	if som_vitoria:
		som_vitoria.play()
	
	print("Vitória no minijogo!")
	
	# Aguarda 1.5 segundos para o som tocar e o jogador ver a interface 
	await get_tree().create_timer(1.5).timeout
	voltar_para_o_menu()

# DERROTA GENERALIZADA PARA TODOS OS JOGOS
func perdeu_minijogo() -> void:
	jogo_finalizado = true
	congelar_minijogo()
	
	# 🔊 Toca o som de erro na hora da derrota absoluta
	if som_erro:
		som_erro.play()
		
	print("Defeat! Voltando para o menu...") 
	await get_tree().create_timer(1.5).timeout 
	voltar_para_o_menu() 

func voltar_para_o_menu() -> void:
	if SceneController: 
		SceneController.change_scene("res://Scenes/Uis/Home.tscn") 

func congelar_minijogo() -> void:
	set_physics_process(false) 
	propagar_congelamento(self) 

func propagar_congelamento(no_atual: Node) -> void:
	for filho in no_atual.get_children(): 
		if filho.name != "ScoreUI": # Não congela a interface de pontos e som! 
			filho.set_physics_process(false) 
			filho.set_process(false) 
			if filho.has_method("stop"): 
				filho.stop() 
			propagar_congelamento(filho) 

func _on_botao_voltar_pressed() -> void:
	print("Jogador desistiu do minijogo. Voltando para o menu...") 
	voltar_para_o_menu() 
