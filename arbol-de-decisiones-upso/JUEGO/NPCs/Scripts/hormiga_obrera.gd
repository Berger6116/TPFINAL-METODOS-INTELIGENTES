extends Node2D
class_name hormiga_obrera

@export var velocidad: float = 80.0
@export var rango_enemigo: float = 150.0
@export var distancia_llegada: float = 20.0

@onready var estado_label: Label = $Label

func _ready() -> void:
	print("HormigaObrera lista en escena: ", get_tree().current_scene.name)

func buscar_nodo(nombre: String) -> Node2D:
	if get_tree().current_scene == null:
		return null
	return get_tree().current_scene.find_child(nombre, true, false) as Node2D

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
	print("Obrera: ¡Huyendo!")
	var dir := enemigo.global_position.direction_to(global_position)
	global_position += dir * velocidad * 1.4 * delta
	rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(enemigo.global_position) > rango_enemigo + 60.0

func hay_comida() -> bool:
	return buscar_nodo("Comida") != null

func ir_a_comida(delta: float) -> bool:
	var comida := buscar_nodo("Comida")
	if comida == null:
		return true
	estado_label.text = "Recolectando comida..."
	print("Obrera: Recolectando comida...")
	var dir := global_position.direction_to(comida.global_position)
	global_position = global_position.move_toward(comida.global_position, velocidad * delta)
	rotation = dir.angle() - Vector2.DOWN.angle()
	if global_position.distance_to(comida.global_position) <= distancia_llegada:
		comida.queue_free()
		print("Obrera: ¡Comida recolectada!")
		return true
	return false

func construir_hormiguero(delta: float) -> void:
	estado_label.text = "Construyendo..."
	#print("Obrera: Construyendo...")
	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and global_position.distance_to(hormiguero.global_position) > distancia_llegada:
		var dir := global_position.direction_to(hormiguero.global_position)
		global_position = global_position.move_toward(hormiguero.global_position, velocidad * delta)
		rotation = dir.angle() - Vector2.DOWN.angle()
