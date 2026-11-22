@tool
extends BTAction

func _generate_name() -> String:
	return "Atacar!"

func _enter() -> void:
	if agent is HormigaGuerrera:
		agent.cambiar_label("Atacando...")

func _tick(_delta: float) -> Status:
	if not (agent is HormigaGuerrera):
		return FAILURE
	# Acá después ponés tu lógica de ataque/persecución:
	agent.atacar(_delta)
	return RUNNING
