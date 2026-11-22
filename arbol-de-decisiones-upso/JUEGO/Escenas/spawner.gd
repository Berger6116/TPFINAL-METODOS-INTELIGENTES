extends Node2D

@export_subgroup("Hormigas")
@export var Hormiguero : Node2D
@export var Obrera : PackedScene
@export var Exploradora : PackedScene
@export var Guerrera : PackedScene

@export_subgroup("Recursos")
@export var comida : PackedScene
@export var basura : PackedScene
@export var enemigo : PackedScene

@onready var ui_container: HBoxContainer = $CanvasLayer/HBoxContainer
@onready var check_comida: CheckButton = $CanvasLayer/HBoxContainer/VBoxContainer2/CheckButton
@onready var check_basura: CheckButton = $CanvasLayer/HBoxContainer/VBoxContainer2/CheckButton2
@onready var check_enemigo: CheckButton = $CanvasLayer/HBoxContainer/VBoxContainer2/CheckButton3

var _checks_recursos: Array[CheckButton] = []


func _ready() -> void:
	ui_container.mouse_filter = Control.MOUSE_FILTER_STOP
	_checks_recursos = [check_comida, check_basura, check_enemigo]
	for check: CheckButton in _checks_recursos:
		check.toggled.connect(_on_check_recurso_toggled.bind(check))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if _instanciar_recurso_en_posicion(get_global_mouse_position()):
				get_viewport().set_input_as_handled()


func _on_check_recurso_toggled(toggled_on: bool, check_activo: CheckButton) -> void:
	if not toggled_on:
		return
	for check: CheckButton in _checks_recursos:
		if check != check_activo:
			check.set_pressed_no_signal(false)


func _obtener_escena_seleccionada() -> PackedScene:
	if check_comida.button_pressed:
		if comida == null:
			push_warning("Spawner: 'comida' no está asignada en el Inspector.")
		return comida
	if check_basura.button_pressed:
		if basura == null:
			push_warning("Spawner: 'basura' no está asignada en el Inspector.")
		return basura
	if check_enemigo.button_pressed:
		if enemigo == null:
			push_warning("Spawner: 'enemigo' no está asignada en el Inspector.")
		return enemigo
	return null


func _instanciar_recurso_en_posicion(posicion: Vector2) -> bool:
	var escena: PackedScene = _obtener_escena_seleccionada()
	if escena == null:
		return false
	var instancia := escena.instantiate() as Node2D
	if instancia == null:
		push_error("Spawner: la escena seleccionada no hereda de Node2D.")
		return false
	var destino: Node = get_tree().current_scene
	if destino == null:
		destino = get_tree().root
	destino.add_child(instancia)
	instancia.global_position = posicion
	return true

func _on_button_pressed() -> void:
#	Obrera
	if Hormiguero == null : return
	if Obrera == null : return
	var npcObrera: Node2D = Obrera.instantiate()
	Hormiguero.get_tree().root.add_child(npcObrera)
	npcObrera.global_position = Hormiguero.global_position
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
#	Exploradora
	if Hormiguero == null : return
	if Exploradora == null : return
	var npcExploradora: Node2D = Exploradora.instantiate()
	Hormiguero.get_tree().root.add_child(npcExploradora)
	npcExploradora.global_position = Hormiguero.global_position
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	#Guerrera
	if Hormiguero == null : return
	if Guerrera == null : return
	var npcGuerrera: Node2D = Guerrera.instantiate()
	Hormiguero.get_tree().root.add_child(npcGuerrera)
	npcGuerrera.global_position = Hormiguero.global_position
	pass # Replace with function body.
	
	
