extends BTAction
class_name BTProcesarObjeto

@export var variable_objeto: StringName = &"objeto_detectado"
@export var variable_tipo: StringName = &"tipo_objeto"

func _tick(_delta: float) -> Status:
	var objeto = agent.objeto_encontrado

	if not is_instance_valid(objeto):
		return FAILURE

	var tipo: String = ""

	if objeto is Basura:
		tipo = "Basura"
	elif objeto is Comida:
		tipo = "Comida"
	else:
		agent.objeto_encontrado = null
		return FAILURE

	blackboard.set_var(variable_objeto, objeto)
	blackboard.set_var(variable_tipo, tipo)

	agent.objeto_encontrado = null

	print("Objeto registrado en Blackboard: ", tipo)
	return SUCCESS
