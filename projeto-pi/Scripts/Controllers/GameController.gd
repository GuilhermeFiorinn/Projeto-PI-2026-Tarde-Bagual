extends Node

var actual_minigame: String 
var actual_day_time: String

var task_list = {
	"build": {
		"title": "Montar barraca",
		"completed": false
	},
	"fish": {
		"title": "Pescar peixes",
		"completed": false
	},
	"chop": {
		"title": "Cortar lenha",
		"completed": false
	}
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
