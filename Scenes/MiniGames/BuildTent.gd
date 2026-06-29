extends MiniGameBase # AGORA HERDA A BASE MODULAR!

@onready var pecas_container = $Pecas
@onready var zonas_snap = $ZonasSnap
@onready var barraca_silueta: Sprite2D = $"BarracaSilueta" # NOVO: Pega a referência da silueta da barraca transparente/opaca

var peca_selecionada: Node2D = null
var offset_mouse: Vector2 = Vector2.ZERO
var distancia_snap: float = 30.0

@onready var mapeamento_posicoes = {
	$Pecas/Parte1: $ZonasSnap/Parte1,
	$Pecas/Parte2: $ZonasSnap/Parte2,
	$Pecas/Parte3: $ZonasSnap/Parte3,
	$Pecas/Parte4: $ZonasSnap/Parte4
}

var pecas_montadas: Array = []

func _ready() -> void:
	super._ready() # Inicializa a UI do MiniGameBase
	for peca in pecas_container.get_children():
		if peca is Area2D:
			peca.input_event.connect(_on_peca_input_event.bind(peca))

func _process(_delta: float) -> void:
	# Impede o arrasto se o jogo base já acabou (congelado)
	if jogo_finalizado: return
	
	if peca_selecionada and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		peca_selecionada.global_position = get_global_mouse_position() - offset_mouse

func _on_peca_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, peca: Node2D) -> void:
	if peca in pecas_montadas or jogo_finalizado:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			peca_selecionada = peca
			offset_mouse = get_global_mouse_position() - peca.global_position
			peca.move_to_front()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if peca_selecionada:
			verificar_snap(peca_selecionada)
			peca_selecionada = null

func verificar_snap(peca: Node2D) -> void:
	var ponto_correto = mapeamento_posicoes[peca]
	var distancia = peca.global_position.distance_to(ponto_correto.global_position)
	
	if distancia <= distancia_snap:
		peca.global_position = ponto_correto.global_position
		pecas_montadas.append(peca)
		peca.modulate = Color(1.2, 1.2, 1.2, 1.0)
		
		# ADICIONADO: Avisa a base que uma peça foi encaixada com sucesso!
		registrar_acerto() 
	else:
		pass

# Customização da vitória específica da barraca antes de mudar de cena
func ganhou_minijogo() -> void:
	if GameController.has_method("complete_task"):
		GameController.complete_task("build_tent")
	
	# NOVO: Esconde o container de todas as peças arrastáveis
	if pecas_container:
		pecas_container.visible = false
		
	# NOVO: Altera o sprite da silueta transparente para a textura da barraca montada e finalizada
	if barraca_silueta:
		barraca_silueta.texture = load("res://Sprites/Icones/barraca.png")
		# Se a sua silueta antiga usava opacidade baixa (modulate transparente), 
		# a linha abaixo redefine para a cor normal (totalmente opaca)
		barraca_silueta.modulate = Color(1, 1, 1, 1) 
	
	# Chama a função original da base para tocar som, travar e mostrar a UI de pontos
	super.ganhou_minijogo()
