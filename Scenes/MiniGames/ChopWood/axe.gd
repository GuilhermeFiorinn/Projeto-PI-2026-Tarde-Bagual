extends CharacterBody2D # VOLTOU PARA CHARACTERBODY2D!

const START_SPEED: float = 400.0
const SPEED_GROWTH: float = 150.0
const AXE_SPEED: float = 1400.0

const START_POSITION: Vector2 = Vector2(100, 100)

var direction = 1
var speed: float = START_SPEED
var inUse: bool = false 

var sprite = 'default'
var last_speed = speed

@onready var george_wachington: CharacterBody2D = $"../Wood"
@onready var minigame_raiz = $".." # Pega o nó raiz ChopWood

func _physics_process(delta: float) -> void:
	# Se o jogo acabou, o machado para imediatamente
	if minigame_raiz and minigame_raiz.jogo_finalizado:
		velocity = Vector2.ZERO
		return
	
	if inUse:
		velocity.x = 0
	else:
		velocity.x = direction * speed
	
	if (direction == -1 and position.x <= 100) or (direction == 1 and position.x >= 1180):
		direction = direction * -1
	
	if Input.is_action_just_pressed("ui_accept"):
		inUse = true
		velocity.y = AXE_SPEED
	
	move_and_slide()
	
	# SE HOUVER COLISÃO: Acertou a lenha!
	if get_slide_collision_count() and inUse:
		inUse = false
		last_speed = speed
		speed = 0
		
		if minigame_raiz and minigame_raiz.has_method("registrar_acerto"):
			minigame_raiz.registrar_acerto()
		
		george_wachington.get_node("Animation").play('choping')
	
	# SE PASSAR DIRETO: Errou a lenha!
	if position.y >= 900:
		position = START_POSITION
		inUse = false
		velocity.y = 0
		speed = START_SPEED
		
		if minigame_raiz and minigame_raiz.has_method("registrar_erro"):
			minigame_raiz.registrar_erro()

func _on_madera_animation_finished() -> void:
	if minigame_raiz and minigame_raiz.jogo_finalizado: return
	
	position = START_POSITION
	speed = last_speed + SPEED_GROWTH
	george_wachington.get_node("Animation").play('default')
