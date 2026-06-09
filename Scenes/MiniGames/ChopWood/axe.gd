extends CharacterBody2D


const START_SPEED: float = 200.0
const SPEED_GROWTH: float = 50.0
const AXE_SPEED: float = 1400.0

const START_POSITION : Vector2 = Vector2(100, 100)

var direction = 1
var speed: float = START_SPEED
var inUse: bool = false 

var sprite = 'default'
var last_speed = speed

@onready var george_wachington: CharacterBody2D  = $"../Wood"

func _physics_process(delta: float) -> void:
	
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
	
	if get_slide_collision_count() and inUse:
		inUse = false
		last_speed = speed
		speed = 0
		
		george_wachington.get_node("Animation").play('choping')
		print_debug('MADEIRAAAAAAAAAAAAAAAAA!!!!!')
	
	if position.y >= 900:
		position = START_POSITION
		inUse = false
		velocity.y = 0
		speed = START_SPEED


func _on_madera_animation_finished() -> void:
	position = START_POSITION
	speed = last_speed + SPEED_GROWTH
	george_wachington.get_node("Animation").play('default')
	pass # Replace with function body.
