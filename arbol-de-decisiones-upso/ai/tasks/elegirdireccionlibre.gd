@tool
extends BTAction
class_name BTElegirDireccionLibre

@export var direccion_var: StringName = &"direccion_elegida"
@export var intervalo_reintento: float = 0.25

var tiempo_reintento: float = 0.0

func _generate_name() -> String:
	return "Elegir dirección libre"

func _enter() -> void:
	tiempo_reintento = 0.0

func _tick(delta: float) -> Status:
	tiempo_reintento -= delta

	if tiempo_reintento > 0.0:
		return RUNNING

	if not is_instance_valid(agent):
		return FAILURE

	var direcciones: Array[Vector2] = agent.obtener_direcciones_disponibles()

	if direcciones.is_empty():
		tiempo_reintento = intervalo_reintento
		return RUNNING

	var direccion_elegida: Vector2 = direcciones.pick_random()

	blackboard.set_var(direccion_var, direccion_elegida)

	return SUCCESS
