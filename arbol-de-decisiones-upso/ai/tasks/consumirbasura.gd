extends BTAction
class_name BTConsumirBasura

@export var cantidad_consumida: int = 1

func _tick(_delta: float) -> Status:
	var objeto = blackboard.get_var("objeto_detectado")

	if not is_instance_valid(objeto) or not objeto is Basura:
		return FAILURE

	var resultado = agent.comprobar_cercania_al_hormiguero()

	if not resultado[0]:
		return FAILURE

	objeto.consumir(cantidad_consumida)

	print("Consumiendo basura. Resistencia restante: ", objeto.resistencia)

	return SUCCESS
