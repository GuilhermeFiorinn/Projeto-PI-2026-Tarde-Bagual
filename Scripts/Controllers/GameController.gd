extends Node

var actual_minigame: String 
var actual_day_time: String

signal task_status_updated

var task_list = {
	"build_tent": {
		"title": "Montar barraca",
		"description": "Encontre um local plano e monte a barraca antes que escureça.",
		"completed": false
	},
	"chop_wood": {
		"title": "Cortar lenha",
		"description": "Pegue o machado e corte alguns troncos para manter a fogueira acesa à noite.",
		"completed": false
	},
	"fish": {
		"title": "Pescar peixes",
		"description": "Vá até o pier no lago e psque alguns peixes para comer.",
		"completed": false
	},
	"tune_the_radio": {
		"title":"Ajustar música no rádio",
		"description": "Ligue o radio e escolho sua estação, ou deixe desligado.",
		"completed": false
	}
}
var mini_games_path = {
	"build_tent": "res://Scenes/MiniGames/BuildTent.tscn",
	"fish":"res://Scenes/MiniGames/FishFishes.tscn",
	"chop_wood":"res://Scenes/MiniGames/ChopWood.tscn",
	"tune_the_radio":"res://Scenes/MiniGames/TuneRadio.tscn",
}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func complete_task(task: String):
	if task_list.has(task):
		task_list[task]["completed"] = true
		task_status_updated.emit()

func _input(event):
	if event is InputEventKey and event.pressed:
		var changed = false
		match event.keycode:
			KEY_1:
				task_list["build_tent"]["completed"] = not task_list["build_tent"]["completed"]
				changed = true
			KEY_2:
				task_list["chop_wood"]["completed"] = not task_list["chop_wood"]["completed"]
				changed = true
			KEY_3:
				task_list["fish"]["completed"] = not task_list["fish"]["completed"]
				changed = true
			KEY_4:
				task_list["tune_the_radio"]["completed"] = not task_list["tune_the_radio"]["completed"]
				changed = true
		if changed:
			task_status_updated.emit()
