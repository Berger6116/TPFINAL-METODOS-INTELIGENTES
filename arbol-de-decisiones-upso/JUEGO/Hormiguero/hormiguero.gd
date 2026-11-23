extends Node2D
class_name gestor_hormiguero

@export var comida:int = 50
@export var obreras:int = 0
@export var guerreras:int = 0
@export var exploradoras:int = 0
@export var integridad:int = 100
@export var limite_region:float = 300.0
const HORMIGA_OBRERA = preload("res://JUEGO/NPCs/TSCNs/HormigaObrera.tscn")
const HORMIGA_EXPLORADORA = preload("res://JUEGO/NPCs/TSCNs/hormiga_exploradora.tscn")
const HORMIGA_GUERRERA = preload("res://JUEGO/NPCs/TSCNs/hormiga_guerrera.tscn")
const ESCENA_FEROMONA = preload("res://JUEGO/Hormiguero/Feromona.tscn")
var rutas_comida: Array[Dictionary] = []

@onready var spawn_obreras = $spawner_obreras
@onready var spawn_exploradoras = $spawner_exploradoras
@onready var spawn_guerreras = $spawner_guerreras

func proceso_spawn() -> void:
	if comida >0:
		comida -= obreras + 2*exploradoras + 3* guerreras
		if comida > 12:
			spawnear_hormigas()
	else:
		integridad -= 1
		if integridad <= 0:
			queue_free()

func registrar_ruta_comida(comida_objetivo: Comida, camino: Array[Vector2]) -> void:
	if not is_instance_valid(comida_objetivo):
		return

	var camino_guardado = camino.duplicate()
	var feromonas: Array[Node2D] = []

	for punto in camino_guardado:
		var feromona = ESCENA_FEROMONA.instantiate()
		add_child(feromona)
		feromona.global_position = punto
		feromonas.append(feromona)

	rutas_comida.append({
		"comida": comida_objetivo,
		"camino": camino_guardado,
		"feromonas": feromonas
	})

	print("Ruta registrada. Cantidad de rutas: ", rutas_comida.size())

func eliminar_ruta_comida(comida_objetivo: Comida) -> void:
	for i in range(rutas_comida.size() - 1, -1, -1):
		var ruta = rutas_comida[i]

		if ruta["comida"] == comida_objetivo:
			for feromona in ruta["feromonas"]:
				if is_instance_valid(feromona):
					feromona.queue_free()

			rutas_comida.remove_at(i)
			print("Ruta eliminada. Cantidad de rutas: ", rutas_comida.size())

func spawnear_hormigas():
	var N = randi_range(0,100)

	if N < 50:
		var obrera = HORMIGA_OBRERA.instantiate()
		get_parent().add_child(obrera)
		obrera.global_position = spawn_obreras.global_position
		obreras += 1
	elif N < 75:
		var exploradora = HORMIGA_EXPLORADORA.instantiate()
		get_parent().add_child(exploradora)
		exploradora.global_position = spawn_exploradoras.global_position
		exploradoras += 1
	else:
		var guerrera = HORMIGA_GUERRERA.instantiate()
		get_parent().add_child(guerrera)
		guerrera.global_position = spawn_guerreras.global_position
		guerreras += 1
