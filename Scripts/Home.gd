extends Node2D

var tasks = GameController.task_list
var paths = GameController.mini_games_path

@onready var task_container = $TaskList/TaskPanel/MarginContainer/VBoxContainer
@onready var task_panel = $TaskList/TaskPanel
@onready var description_label = $TaskList/TaskPanel/DescriptionLabel
@onready var imagem_final = $Final # NOVO: Referência para a tela/imagem final

func _ready():
	$GamesButtons/ButtonBuild.tooltip_text = tasks["build_tent"]["title"]
	$GamesButtons/ButtonChop.tooltip_text = tasks["chop_wood"]["title"]
	$GamesButtons/ButtonFish.tooltip_text = tasks["fish"]["title"]
	$GamesButtons/ButtonFireFly.tooltip_text = tasks["catch_fireflies"]["title"]
	
	task_panel.visible = false
	
	# NOVO: Garante que a imagem final comece escondida ao iniciar o jogo
	if imagem_final:
		imagem_final.visible = false
		
	if description_label:
		description_label.text = ""
		
	create_task_list()
	verificar_fim_do_jogo() # NOVO: Checa se o jogador já começa com tudo feito (testes)
	
	# Atualiza a lista e checa a vitória quando o estado de alguma tarefa muda
	GameController.task_status_updated.connect(create_task_list)
	GameController.task_status_updated.connect(verificar_fim_do_jogo) # NOVO

func _process(delta: float) -> void:
	pass

func create_task_list():
	print_debug("ola")
	# Remove tasks antigas
	for child in task_container.get_children():
		child.queue_free()

	# Cria tasks
	for task_key in tasks:
		var task = tasks[task_key]
		var rich_text = RichTextLabel.new()
		
		# Configurações básicas do RichTextLabel
		rich_text.bbcode_enabled = true
		rich_text.fit_content = true
		rich_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
		rich_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rich_text.custom_minimum_size.x = 200

		var task_title = task["title"]

		# Visual de concluído vs Incompleto
		if task["completed"]:
			rich_text.text = "[color=gray][s]" + task_title + "[/s][/color]"
		else:
			rich_text.text = "[url=" + task_key + "]" + task_title + "[/url]"
			rich_text.meta_clicked.connect(_on_task_clicked)

		task_container.add_child(rich_text)

# NOVO: Função para verificar se todas as tarefas do dicionário foram concluídas
func verificar_fim_do_jogo():
	var todas_concluidas = true
	
	for task_key in tasks:
		if tasks[task_key]["completed"] == false:
			todas_concluidas = false
			break # Se achar uma tarefa falsa, já interrompe o loop
			
	if todas_concluidas:
		print("Todas as tarefas concluídas! Mostrando tela final.")
		if imagem_final:
			imagem_final.visible = true
			# Opcional: Esconde os botões e a lista para focar apenas na imagem final
			$GamesButtons.visible = false 
			$TaskList.visible = false
	else:
		if imagem_final:
			imagem_final.visible = false
			$GamesButtons.visible = true

func _on_task_clicked(meta):
	var task_key = str(meta)
	if tasks.has(task_key) and tasks[task_key].has("description"):
		description_label.text = tasks[task_key]["description"]
	else:
		description_label.text = "Descrição não disponível."

func _on_list_button_pressed() -> void:
	task_panel.visible = !task_panel.visible

func _on_button_build_pressed() -> void:
	SceneController.change_scene(paths["build_tent"])

func _on_button_chop_pressed() -> void:
	SceneController.change_scene(paths["chop_wood"])

func _on_button_fish_pressed() -> void:
	SceneController.change_scene(paths["fish"])

func _on_button_radio_pressed() -> void:
	SceneController.change_scene(paths["tune_the_radio"])

func _on_button_fire_fly_pressed() -> void:
	SceneController.change_scene(paths["catch_fireflies"])
