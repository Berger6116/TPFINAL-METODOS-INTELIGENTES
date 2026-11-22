@tool
extends BTAction

@export var velocidad: float = 150.0
@export var distancia_llegada: float = 20.0

func _enter() -> void:
	var cartel := agent.get_node_or_null("Label")
	if cartel:
		cartel.text = "Recolectando comida..."

func _tick(delta: float) -> Status:
	var comida: Node2D = blackboard.get_var("objetivo_comida")
	if not is_instance_valid(comida):
		return FAILURE

	agent.global_position = agent.global_position.move_toward(comida.global_position, velocidad * delta)

	if agent.global_position.distance_to(comida.global_position) <= distancia_llegada:
		comida.queue_free()
		return SUCCESS

	return RUNNING
