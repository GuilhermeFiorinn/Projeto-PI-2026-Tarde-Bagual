extends Control 

var animationPlayer: AnimationPlayer
var fades: ColorRect
var fadesAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if ($AnimationPlayer != null):
		#animationPlayer = $AnimationPlayer
	if ($FadesTransactions != null):
		fades = $FadesTransactions
		fadesAnimation = $FadesTransactions/AnimationPlayer
	else: 
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func change_scene(scene):
	#animationPlayer.play("fade_in")
	#await animationPlayer.animation_finished
	#fades.show()
	#fadesAnimation.play("fade_in")
	#await fadesAnimation.animation_finished
	
	get_tree().change_scene_to_file(scene)
	
	#fadesAnimation.play("fade_out")
