@tool
extends BTAction

@export var velocidad: float = 200.0
@export var distancia_segura: float = 260.0

func _enter() -> void:
	var cartel := agent.get_node_or_null("Label")
	if cartel:
		cartel.text = "¡Huyendo!"

func _tick(delta: float) -> Status:
	var enemigo: Node2D = blackboard.get_var("enemigo_cercano")
	if not is_instance_valid(enemigo):
		return SUCCESS

	var direccion_escape := enemigo.global_position.direction_to(agent.global_position)
	agent.global_position += direccion_escape * velocidad * delta

	if agent.global_position.distance_to(enemigo.global_position) >= distancia_segura:
		return SUCCESS

	return RUNNING
