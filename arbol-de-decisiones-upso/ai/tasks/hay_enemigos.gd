@tool
extends BTCondition

@export var rango_deteccion: float = 200.0

func _tick(_delta: float) -> Status:
	var enemigos := agent.get_tree().get_nodes_in_group("enemigos")
	for enemigo in enemigos:
		if agent.global_position.distance_to(enemigo.global_position) <= rango_deteccion:
			blackboard.set_var("enemigo_cercano", enemigo)
			return SUCCESS
	return FAILURE
