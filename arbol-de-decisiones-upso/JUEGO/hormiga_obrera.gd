extends Node2D

@export var velocidad: float = 90.0
@export var rango_enemigo: float = 300.0
@export var distancia_llegada: float = 25.0

@onready var estado_label: Label = $Label
@onready var sprite: Sprite2D = $Sprite2D

var llevando_comida: bool = false
var comida_en_mano: Node2D = null
var comida_objetivo: Node2D = null
var ruta_actual: Array = []
var indice_punto: int = 0

func buscar_nodo(nombre: String) -> Node2D:
	var escena := get_tree().current_scene
	if escena == null:
		return null
	return escena.find_child(nombre, true, false) as Node2D

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
	return llevando_comida or not obtener_ruta_valida().is_empty()

func mover_hacia(destino: Vector2, delta: float) -> bool:
	var dir := global_position.direction_to(destino)
	global_position = global_position.move_toward(destino, velocidad * delta)
	if dir.length() > 0.01:
		sprite.rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(destino) <= distancia_llegada

func ir_a_comida(delta: float) -> bool:
	# PASO 1: Ir hacia la comida siguiendo SOLO las feromonas de la exploradora
	if not llevando_comida:
		if not is_instance_valid(comida_objetivo) or ruta_actual.is_empty():
			var ruta := obtener_ruta_valida()
			if ruta.is_empty():
				return true
			comida_objetivo = ruta["comida"]
			ruta_actual = ruta["camino"].duplicate()
			if ruta_actual[0].distance_to(comida_objetivo.global_position) < ruta_actual[-1].distance_to(comida_objetivo.global_position):
				ruta_actual.reverse()
			indice_punto = 0
			print("Obrera: ¡Ruta de feromonas encontrada! Puntos: ", ruta_actual.size())

		estado_label.text = "Siguiendo feromonas..."
		if indice_punto < ruta_actual.size():
			if mover_hacia(ruta_actual[indice_punto], delta):
				indice_punto += 1
			return false

		# Terminó los puntos: agarra la comida
		if is_instance_valid(comida_objetivo):
			if mover_hacia(comida_objetivo.global_position, delta):
				llevando_comida = true
				comida_en_mano = comida_objetivo
				indice_punto = ruta_actual.size() - 1
				print("Obrera: ¡Comida agarrada! Volviendo por las feromonas...")
			return false
		else:
			ruta_actual.clear()
			return true

	# PASO 2: Volver al hormiguero siguiendo las feromonas al revés
	estado_label.text = "Llevando al hormiguero..."
	if is_instance_valid(comida_en_mano):
		comida_en_mano.global_position = global_position

	if indice_punto >= 0 and indice_punto < ruta_actual.size():
		if mover_hacia(ruta_actual[indice_punto], delta):
			indice_punto -= 1
		return false

	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and not mover_hacia(hormiguero.global_position, delta):
		return false

	# Entregó la comida y resetea todo
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

func buscar_enemigo_cercano() -> Node2D:
	var escena := get_tree().current_scene
	if escena == null:
		return null
	var mas_cercano: Node2D = null
	var menor_distancia: float = INF
	for nodo in escena.find_children("*", "Node2D", true, false):
		if is_instance_valid(nodo) and (nodo.scene_file_path.ends_with("Enemigo.tscn") or nodo.name.begins_with("Enemigo")):
			var dist := global_position.distance_to(nodo.global_position)
			if dist < menor_distancia:
				menor_distancia = dist
				mas_cercano = nodo
	return mas_cercano

func hay_enemigo_cerca() -> bool:
	var enemigo := buscar_enemigo_cercano()
	if enemigo != null:
		return global_position.distance_to(enemigo.global_position) <= rango_enemigo
	return false

func huir_de_enemigo(delta: float) -> bool:
	var enemigo := buscar_enemigo_cercano()
	if enemigo == null:
		return true
	estado_label.text = "¡Huyendo!"
	var dir := enemigo.global_position.direction_to(global_position)
	global_position += dir * velocidad * 1.5 * delta
	sprite.rotation = dir.angle() - Vector2.DOWN.angle()
	return global_position.distance_to(enemigo.global_position) > rango_enemigo + 80.0

func construir_hormiguero(delta: float) -> void:
	if estado_label.text != "Construyendo...":
		estado_label.text = "Construyendo..."
	var hormiguero := buscar_nodo("Hormiguero")
	if hormiguero != null and global_position.distance_to(hormiguero.global_position) > distancia_llegada + 5.0:
		mover_hacia(hormiguero.global_position, delta)
