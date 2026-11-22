@tool
extends BTAction

func _generate_name() -> String:
	return "Atacar!"

func _enter() -> void:
	if agent is HormigaGuerrera:
		agent.cambiar_label("Atacando...")

func _tick(delta: float) -> Status:
	if not (agent is HormigaGuerrera):
		return FAILURE

	var termino: bool = agent.atacar(delta)
	if termino:
		return SUCCESS

	return RUNNING
