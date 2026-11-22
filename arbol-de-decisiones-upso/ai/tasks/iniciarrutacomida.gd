extends BTAction
class_name BTIniciarRegresoComida

@export var distancia_llegada: float = 5.0

func _tick(delta: float) -> Status:
	if not is_instance_valid(agent.hormiguero_actual):
		return FAILURE

	# Obtener el calculador desde Mundo.
	var calculador = agent.get_parent().get_node_or_null("CalculadorCaminos")

	if calculador == null:
		return FAILURE

	# Calcular el camino solamente al comenzar el regreso.
	if not agent.volviendo_al_hormiguero:
		var destino = agent.hormiguero_actual.global_position

		agent.camino_regreso = calculador.obtener_camino(
			agent.global_position,
			destino
		)

		if agent.camino_regreso.is_empty():
			return FAILURE

		agent.indice_punto_camino = 0
		agent.volviendo_al_hormiguero = true
		

	# Comprobar que todavía queden puntos.
	if agent.indice_punto_camino >= agent.camino_regreso.size():
		var comida = blackboard.get_var("objeto_detectado")

		if is_instance_valid(comida) and comida is Comida:
			var camino_guardado = agent.camino_regreso.duplicate()
			camino_guardado.reverse()
			agent.hormiguero_actual.registrar_ruta_comida(comida, camino_guardado)

		agent.volviendo_al_hormiguero = false
		agent.camino_regreso.clear()
		return SUCCESS

	# Obtener el siguiente punto.
	var punto = agent.camino_regreso[agent.indice_punto_camino]
	var distancia = agent.global_position.distance_to(punto)

	# Pasar al siguiente punto si ya llegó.
	if distancia <= distancia_llegada:
		agent.indice_punto_camino += 1
		return RUNNING

	# Orientarse hacia el punto.
	var direccion = (punto - agent.global_position).normalized()

	if agent.direccion_actual.distance_to(direccion) > 0.01:
		agent.cambiar_direccion_a(direccion)

	# Avanzar hacia el punto.
	agent.global_position += direccion * agent.velocidad * delta

	return RUNNING
