extends Node2D

var tasks = GameController.task_list
var paths = GameController.mini_games_path

func _ready():
	$Control/ButtonBuild.tooltip_text = tasks["build_tent"]["title"]
	$Control/ButtonChop.tooltip_text = tasks["chop_wood"]["title"]
	$Control/ButtonFish.tooltip_text = tasks["fish"]["title"]


func _process(delta: float) -> void:
	pass


func _on_button_build_pressed() -> void:
	SceneController.change_scene(paths["build_tent"])


func _on_button_chop_pressed() -> void:
	SceneController.change_scene(paths["chop_wood"])


func _on_button_fish_pressed() -> void:
	SceneController.change_scene(paths["fish"])
