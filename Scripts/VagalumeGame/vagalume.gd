extends Node2D

# Sinais para avisar o minijogo principal
signal vagalume_capturado
signal vagalume_sumiu # NOVO: Sinalizador de erro!

@onready var area_2d: Area2D = $Area2D
@onready var timer_sumir: Timer = $Area2D/TimerSumir

func _ready() -> void:
	timer_sumir.wait_time = 2.0
	timer_sumir.one_shot = true
	timer_sumir.timeout.connect(_on_timer_sumir_timeout)
	timer_sumir.start()
	
	area_2d.input_event.connect(_on_area_2d_input_event)

# Detecta o clique do mouse/toque na tela [cite: 80, 87]
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("vagalume_capturado")
		queue_free() 

# Se o tempo acabar antes do jogador clicar, ele some sozinho
func _on_timer_sumir_timeout() -> void:
	emit_signal("vagalume_sumiu") # NOVO: Avisa que o jogador falhou no tempo! 
	queue_free()
