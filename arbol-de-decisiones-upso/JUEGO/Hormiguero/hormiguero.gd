extends Node2D
class_name gestor_hormiguero

@export var comida:int = 50
@export var obreras:int = 0
@export var guerreras:int = 0
@export var exploradoras:int = 0
@export var integridad:int = 100
@export var limite_region:float = 150.0
const ESCENA_FEROMONA = preload("res://JUEGO/Hormiguero/Feromona.tscn")
var rutas_comida: Array[Dictionary] = []

func _process(delta: float) -> void:
	if comida >0:
		comida -= obreras + 2*exploradoras + 3* guerreras
		if comida > 12:
			obreras += 1
			exploradoras += 1
			guerreras +=1
			#spawnear_hormigas()
	else:
		integridad -= 1

func registrar_ruta_comida(comida_objetivo: Comida, camino: Array[Vector2]) -> void:
	if not is_instance_valid(comida_objetivo):
		return

	var camino_guardado = camino.duplicate()

	rutas_comida.append({
		"comida": comida_objetivo,
		"camino": camino_guardado
	})

	for punto in camino_guardado:
		var feromona = ESCENA_FEROMONA.instantiate()
		add_child(feromona)
		feromona.global_position = punto

	print("Ruta registrada. Cantidad de rutas: ", rutas_comida.size())
