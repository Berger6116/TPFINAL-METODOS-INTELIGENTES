@tool
extends BTCondition
class_name BTDetectarObstaculo

func _generate_name() -> String:
	return "Detectar obstáculo"

func _tick(_delta: float) -> Status:
	if not is_instance_valid(agent):
		return FAILURE

	if not agent.has_method("comprobar_obstaculo"):
		return FAILURE

	if agent.comprobar_obstaculo():
		return SUCCESS

	return FAILURE
