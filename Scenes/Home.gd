extends Node2D

var tasks = GameController.task_list
var paths = GameController.mini_games_path

@onready var task_container = $TaskList/TaskPanel/MarginContainer/VBoxContainer
@onready var task_panel = $TaskList/TaskPanel

func _ready():
	$Control/ButtonBuild.tooltip_text = tasks["build_tent"]["title"]
	$Control/ButtonChop.tooltip_text = tasks["chop_wood"]["title"]
	$Control/ButtonFish.tooltip_text = tasks["fish"]["title"]

	task_panel.visible = false
	create_task_list()

func _process(delta: float) -> void:	
	pass

func create_task_list():

	# Remove tasks antigas
	for child in task_container.get_children():
		child.queue_free()

	# Cria tasks
	for task_key in tasks:
		var task = tasks[task_key]
		var checkbox = CheckBox.new()

		checkbox.text = task["title"]
		checkbox.button_pressed = task["completed"]
		# Jogador não pode clicar
		checkbox.mouse_filter = Control.MOUSE_FILTER_IGNORE

		# Visual de concluído
		if task["completed"]:
			checkbox.modulate = Color.GRAY

		task_container.add_child(checkbox)

func _on_list_button_pressed() -> void:
	task_panel.visible = !task_panel.visible
	
func _on_button_build_pressed() -> void:
	SceneController.change_scene(paths["build_tent"])


func _on_button_chop_pressed() -> void:
	SceneController.change_scene(paths["chop_wood"])


func _on_button_fish_pressed() -> void:
	SceneController.change_scene(paths["fish"])
