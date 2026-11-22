extends BTAction
class_name BTMostrarAccionObjeto

func _tick(_delta: float) -> Status:
	var tipo = blackboard.get_var("tipo_objeto")

	match tipo:
		"Basura":
			agent.get_node("AccionObjeto").text = "Encontré basura"
		"Comida":
			agent.get_node("AccionObjeto").text = "Encontré comida"
		_:
			return FAILURE

	return SUCCESS
