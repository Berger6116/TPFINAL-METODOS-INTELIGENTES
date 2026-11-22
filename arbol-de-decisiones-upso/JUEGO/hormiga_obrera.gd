extends Node2D

@export var velocidad: float = 90.0
@export var rango_enemigo: float = 160.0
@export var distancia_llegada: float = 25.0
@export var distancia_llegada: float = 20.0

@onready var estado_label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

var llevando_comida: bool = false
var comida_en_mano: Node2D = null
var comida_objetivo: Node2D = null
var ruta_actual: Array[Vector2] = []
var indice_punto: int = 0

func buscar_nodo(nombre: String) -> Node2D:
	var escena := get_tree().current_scene
	if escena == null:
		return null
	return escena.find_child(nombre, true, false) as Node2D

func buscar_comida_suelta() -> Node2D:
	var escena := get_tree().current_scene
	if escena == null:
		return null
	var mas_cercana: Node2D = null
	var menor_distancia: float = INF
	for hijo in escena.get_children():
		if hijo is Node2D and hijo.name.begins_with("Comida") and is_instance_valid(hijo):
			var dist := global_position.distance_to(hijo.global_position)
			if dist < menor_distancia:
				menor_distancia = dist
				mas_cercana = hijo
	return mas_cercana

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
	sprite.rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(enemigo.global_position) > rango_enemigo + 80.0

func obtener_ruta_valida() -> Dictionary:
	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero == null or not ("rutas_comida" in hormiguero):
		return {}
	for ruta in hormiguero.rutas_comida:
		var c = ruta.get("comida")
		var camino = ruta.get("camino", [])
		if is_instance_valid(c) and camino.size() > 0:
			return ruta
	return {}

func hay_comida() -> bool:
	if llevando_comida:
		return true
	if not obtener_ruta_valida().is_empty():
		return true
	return buscar_comida_suelta() != null

func mover_hacia(destino: Vector2, delta: float) -> bool:
	var dir := global_position.direction_to(destino)
	global_position = global_position.move_toward(destino, velocidad * delta)
	if dir.length() > 0.01:
		sprite.rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(destino) <= distancia_llegada

func ir_a_comida(delta: float) -> bool:
	# PASO 1: Ir hacia la comida (siguiendo feromonas si hay ruta, o directo si no)
	if not llevando_comida:
		if not is_instance_valid(comida_objetivo):
			ruta_actual.clear()
			var ruta := obtener_ruta_valida()
			if not ruta.is_empty():
				comida_objetivo = ruta["comida"]
				ruta_actual = ruta["camino"].duplicate()
				if ruta_actual[0].distance_to(comida_objetivo.global_position) < ruta_actual[-1].distance_to(comida_objetivo.global_position):
					ruta_actual.reverse()
				indice_punto = 0
			else:
				comida_objetivo = buscar_comida_suelta()
				if comida_objetivo == null:
					return true

		if not ruta_actual.is_empty() and indice_punto < ruta_actual.size():
			estado_label.text = "Siguiendo feromonas..."
			if mover_hacia(ruta_actual[indice_punto], delta):
				indice_punto += 1
			return false

		if is_instance_valid(comida_objetivo):
			estado_label.text = "Buscando comida..."
			if mover_hacia(comida_objetivo.global_position, delta):
				llevando_comida = true
				comida_en_mano = comida_objetivo
				indice_punto = ruta_actual.size() - 1
				print("Obrera: ¡Comida agarrada! Volviendo al hormiguero...")
			return false
		else:
			ruta_actual.clear()
			return true

	# PASO 2: Volver al hormiguero (por las feromonas al revés si había ruta)
	estado_label.text = "Llevando al hormiguero..."
	if is_instance_valid(comida_en_mano):
		comida_en_mano.global_position = global_position

	if not ruta_actual.is_empty() and indice_punto >= 0 and indice_punto < ruta_actual.size():
		if mover_hacia(ruta_actual[indice_punto], delta):
			indice_punto -= 1
		return false

	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and not mover_hacia(hormiguero.global_position, delta):
		return false

	# Entregó la comida y resetea todo para poder volver a salir
	if is_instance_valid(comida_en_mano):
		comida_en_mano.queue_free()
	if hormiguero != null and "comida" in hormiguero:
		hormiguero.comida += 10
	comida_en_mano = null
	comida_objetivo = null
	ruta_actual.clear()
	llevando_comida = false
	print("Obrera: ¡Comida entregada en el hormiguero!")
	return true

func construir_hormiguero(delta: float) -> void:
	if estado_label.text != "Construyendo...":
		estado_label.text = "Construyendo..."
	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and global_position.distance_to(hormiguero.global_position) > distancia_llegada + 5.0:
		mover_hacia(hormiguero.global_position, delta)
