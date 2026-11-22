extends BTAction
class_name BTProcesarObjetoExploradora

func _tick(_delta: float) -> Status:
	var tipo = blackboard.get_var("tipo_objeto")
	var objeto = blackboard.get_var("objeto_detectado")

	match tipo:
		"Basura":
			agent.get_node("AccionObjeto").text = "Encontré basura"
		"Comida":
			agent.get_node("AccionObjeto").text = "Encontré comida"
			if not is_instance_valid(objeto) or not objeto is Comida:
				return FAILURE
			blackboard.set_var("enrutandose", objeto.enrutandose)
		_:
			return FAILURE

	return SUCCESS
