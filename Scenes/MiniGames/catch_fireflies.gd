extends MiniGameBase # Herda o sistema de pontuação modular!

const VAGALUME_SCENE = preload("res://Scripts/VagalumeGame/vagalume.tscn")

@onready var timer_spawn: Timer = $TimerSpawn
@onready var marcadores_spawn: Node2D = $MarcadoresSpawn

func _ready() -> void:
	super._ready()
	
	timer_spawn.wait_time = 1.2
	timer_spawn.timeout.connect(_on_timer_spawn_timeout)
	timer_spawn.start()

func _on_timer_spawn_timeout() -> void:
	if jogo_finalizado: return # Evita criar novos vagalumes após o fim
	
	var lista_posicoes = marcadores_spawn.get_children()
	if lista_posicoes.size() == 0: return
	
	var marcador_aleatorio = lista_posicoes.pick_random()
	
	var novo_vagalume = VAGALUME_SCENE.instantiate()
	novo_vagalume.position = marcador_aleatorio.position
	
	novo_vagalume.connect("vagalume_capturado", _on_vagalume_capturado)
	novo_vagalume.connect("vagalume_sumiu", _on_vagalume_fugiu)
	
	add_child(novo_vagalume)

func _on_vagalume_capturado() -> void:
	registrar_acerto() 

func _on_vagalume_fugiu() -> void:
	registrar_erro() 

# Sobrescrevemos as funções chamando o super() no final!
func ganhou_minijogo() -> void:
	timer_spawn.stop()
	print("Minigame de Vagalumes Concluído com Vitória!")
	if GameController.has_method("complete_task"):
		GameController.complete_task("catch_fireflies")
	super() # CORREÇÃO: Chama o MiniGameBase para tocar o som e voltar à Home

func perdeu_minijogo() -> void:
	timer_spawn.stop()
	print("Game Over! Muitos vagalumes fugiram.")
	super() # CORREÇÃO: Chama o MiniGameBase para congelar e voltar à Home
