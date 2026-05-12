extends Node

var animationPlayer: AnimationPlayer
var fades: ColorRect
var fadesAnimation

func _ready() -> void:
	if ($FadesTransactions != null):
		fades = $FadesTransactions
		fadesAnimation = $FadesTransactions/AnimationPlayer

func change_scene(scene):
	fadesAnimation.play("fade_in")
	await fadesAnimation.animation_finished
	
	get_tree().change_scene_to_file(scene)
	
	await get_tree().process_frame
	fadesAnimation.play("fade_out")
