@tool
extends BTAction
class_name BTCambiarDireccion

@export var direccion_var: StringName = &"direccion_elegida"

func _generate_name() -> String:
	return "Cambiar dirección"

func _tick(_delta: float) -> Status:
	if not is_instance_valid(agent):
		return FAILURE

	var direccion: Vector2 = blackboard.get_var(direccion_var, Vector2.ZERO)

	if direccion == Vector2.ZERO:
		return FAILURE

	if not agent.has_method("cambiar_direccion_a"):
		return FAILURE

	agent.cambiar_direccion_a(direccion)

	return SUCCESS
