extends Node2D

@export var velocidad: float = 90.0
@export var rango_enemigo: float = 160.0
@export var distancia_llegada: float = 25.0

@onready var estado_label: Label = $Label

var direccion_caminar: Vector2 = Vector2.RIGHT
var tiempo_giro: float = 0.0
var llevando_comida: bool = false
var comida_en_mano: Node2D = null

func buscar_nodo(nombre: String) -> Node2D:
	var escena := get_tree().current_scene
	if escena == null:
		return null
	return escena.find_child(nombre, true, false) as Node2D

func hay_enemigo_cerca() -> bool:
	var enemigo := buscar_nodo("Enemigo")
	if enemigo != null:
		return global_position.distance_to(enemigo.global_position) <= rango_enemigo
	return false

func huir_de_enemigo(delta: float) -> bool:
	var enemigo := buscar_nodo("Enemigo")
	if enemigo == null:
		return true
	estado_label.text = "¡Huyendo!"
	var dir := enemigo.global_position.direction_to(global_position)
	global_position += dir * velocidad * 1.5 * delta
	rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(enemigo.global_position) > rango_enemigo + 80.0

func hay_comida() -> bool:
	return llevando_comida or buscar_nodo("Comida") != null

func ir_a_comida(delta: float) -> bool:
	# Paso 1: Si todavía no la agarró, camina hasta la Comida
	if not llevando_comida:
		var comida := buscar_nodo("Comida")
		if comida == null or not is_instance_valid(comida):
			return true
		estado_label.text = "Buscando comida..."
		var dir := global_position.direction_to(comida.global_position)
		global_position = global_position.move_toward(comida.global_position, velocidad * delta)
		rotation = dir.angle() - Vector2.DOWN.angle()
		if global_position.distance_to(comida.global_position) <= distancia_llegada:
			llevando_comida = true
			comida_en_mano = comida
			print("Obrera: ¡Agarré la comida! Llevándola al hormiguero...")
		return false

	# Paso 2: Si ya la tiene, la lleva hasta el Hormiguero
	estado_label.text = "Llevando al hormiguero..."
	if is_instance_valid(comida_en_mano):
		comida_en_mano.global_position = global_position

	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero == null:
		if is_instance_valid(comida_en_mano):
			comida_en_mano.queue_free()
		comida_en_mano = null
		llevando_comida = false
		return true

	var dir_casa := global_position.direction_to(hormiguero.global_position)
	global_position = global_position.move_toward(hormiguero.global_position, velocidad * delta)
	rotation = dir_casa.angle() - Vector2.DOWN.angle()

	if global_position.distance_to(hormiguero.global_position) <= distancia_llegada:
		if is_instance_valid(comida_en_mano):
			comida_en_mano.queue_free()
		comida_en_mano = null
		llevando_comida = false
		print("Obrera: ¡Comida entregada en el hormiguero!")
		return true

	return false

func construir_hormiguero(delta: float) -> void:
	estado_label.text = "Construyendo..."
	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and global_position.distance_to(hormiguero.global_position) > distancia_llegada:
		var dir := global_position.direction_to(hormiguero.global_position)
		global_position = global_position.move_toward(hormiguero.global_position, velocidad * delta)
		rotation = dir.angle() - Vector2.DOWN.angle()
	estado_label.rotation = -rotation
