extends Node2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_play_button_pressed() -> void:
	print_debug("ola")
	SceneController.change_scene("res://Scenes/sceneTest1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
