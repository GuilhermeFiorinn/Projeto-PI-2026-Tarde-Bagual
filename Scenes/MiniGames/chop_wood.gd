extends MiniGameBase # ESTE herda o sistema de score!

func _ready() -> void:
	super._ready() # Inicia a interface e o som de vitória

func ganhou_minijogo() -> void:
	print("Tora de madeira cortada por completo!")
	if GameController.has_method("complete_task"):
		GameController.complete_task("chop_wood")
	super.ganhou_minijogo() # Toca som e volta para a Home

func perdeu_minijogo() -> void:
	print("Game Over! Você gastou todas as chances.")
	super.perdeu_minijogo() # Volta para a Home
