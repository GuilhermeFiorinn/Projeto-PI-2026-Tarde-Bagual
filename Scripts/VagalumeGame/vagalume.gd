extends Node2D

# Sinais para avisar o minijogo principal
signal vagalume_capturado
signal vagalume_sumiu 

@onready var area_2d: Area2D = $Area2D
@onready var timer_sumir: Timer = $Area2D/TimerSumir

# --- VARIÁVEIS DE MOVIMENTO CALIBRADAS (MAIS DIFÍCIL) ---
var velocidade: float = 180.0       # DOBRO DA VELOCIDADE: Voo super rápido (era 120.0) 
var direcao: Vector2 = Vector2.ZERO # Direção atual do movimento 
var tempo_mudar_direcao: float = 0.0 # Timer interno para as guinadas 

func _ready() -> void:
	# Mantém os 2 segundos normais de vida na tela antes de sumir 
	timer_sumir.wait_time = 2.0
	timer_sumir.one_shot = true
	timer_sumir.timeout.connect(_on_timer_sumir_timeout) 
	timer_sumir.start() 
	
	area_2d.input_event.connect(_on_area_2d_input_event) 
	
	# Sorteia a direção inicial do voo 
	escolher_direcao_aleatoria()

func _process(delta: float) -> void:
	# Move o vagalume de forma veloz na tela 
	position += direcao * velocidade * delta 
	
	# Diminui o tempo restante até a próxima mudança drástica de direção 
	tempo_mudar_direcao -= delta 
	if tempo_mudar_direcao <= 0:
		escolher_direcao_aleatoria() 

# Sorteia um novo ângulo de voo de forma muito mais frequente
func escolher_direcao_aleatoria() -> void:
	var angulo_aleatorio = randf_range(0, 2 * PI) 
	direcao = Vector2(cos(angulo_aleatorio), sin(angulo_aleatorio)).normalized() 
	
	# RITMO FRENÉTICO: Agora ele muda de direção a cada 0.1 a 0.3 segundos (era 0.3 a 0.7)
	# Isso vai fazer ele parecer uma mosca ou um inseto ziguezagueando muito rápido!
	tempo_mudar_direcao = randf_range(0.1, 0.3) 

# Detecta o clique do mouse/toque na tela 
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void: 
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: 
		emit_signal("vagalume_capturado") 
		queue_free()  

# Se o tempo acabar antes do jogador clicar, ele some sozinho 
func _on_timer_sumir_timeout() -> void: 
	emit_signal("vagalume_sumiu") # Avisa que o jogador falhou no tempo! 
	queue_free() 
