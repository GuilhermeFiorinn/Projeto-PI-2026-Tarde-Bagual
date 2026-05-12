extends Node

var actual_minigame: String 
var actual_day_time: String

var task_list = {
	"build_tent": {
		"title": "Montar barraca",
		"completed": false
	},
	"fish": {
		"title": "Pescar peixes",
		"completed": false
	},
	"chop_wood": {
		"title": "Cortar lenha",
		"completed": false
	},
	"tune_the_radio": {
		"title":"Ajustar música no rádio",
		"completed": false
	}
}
var mini_games_path = {
	"build_tent": "res://Scenes/MiniGames/BuildTent.tscn",
	"fish":"res://Scenes/MiniGames/FishFishes.tscn",
	"chop_wood":"res://Scenes/MiniGames/ChopWood.tscn",
	"tune_the_radio":"res://Scenes/MiniGames/TuneRadio.tscn",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func complete_task(task):
	if (task != null):
		task_list[task]["completed"] = true
