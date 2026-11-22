extends BTAction
class_name BTAcercarseObjeto

@export var distancia_minima: float = 12.0

func _tick(_delta: float) -> Status:
	var objeto = blackboard.get_var("objeto_detectado")

	if not is_instance_valid(objeto):
		return FAILURE

	var direccion = (objeto.global_position - agent.global_position).normalized()
	var distancia = agent.global_position.distance_to(objeto.global_position)
	print("Distancia: ", distancia, " | Posición hormiga: ", agent.global_position, " | Posición objeto: ", objeto.global_position)
	if distancia <= distancia_minima:
		return SUCCESS

	agent.cambiar_direccion_a(direccion)
	agent.deambular(_delta)
	return RUNNING
