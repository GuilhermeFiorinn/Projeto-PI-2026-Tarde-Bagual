extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	PlayMusic(load("res://Audios/Songs/musica.ogg"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func PlayMusic(music_stream: AudioStream):
	print_debug("musica tocou?")
	if stream != music_stream:
		stream = music_stream
		play()
