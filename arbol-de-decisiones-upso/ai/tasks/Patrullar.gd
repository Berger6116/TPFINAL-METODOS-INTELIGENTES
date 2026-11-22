@tool
extends BTAction


func _generate_name() -> String:
	return "Patrullar!"


func _enter() -> void:
	if agent is HormigaGuerrera:
		agent.preparar_paso_patrulla()
		agent.cambiar_label("Patrullando")


func _tick(delta: float) -> Status:
	if not (agent is HormigaGuerrera):
		return FAILURE

	if agent.objetivo_actual == null:
		return FAILURE

	agent.patrullar(delta)

	if agent.en_objetivo:
		agent.avanzar_paso_patrulla()
		return SUCCESS

	return RUNNING
