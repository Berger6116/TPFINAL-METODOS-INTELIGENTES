@tool
extends BTAction


func _generate_name() -> String:
	return "Defender Hormiguero"


func _enter() -> void:
	if agent is HormigaGuerrera:
		agent.preparar_ir_al_hormiguero()
		agent.cambiar_label("Volviendo al hormiguero")


func _tick(delta: float) -> Status:
	if not (agent is HormigaGuerrera):
		return FAILURE

	if agent.objetivo_actual == null:
		return FAILURE
	if agent is HormigaGuerrera:
		agent.ir_al_hormiguero(delta)

	if agent.en_objetivo:
		agent.reiniciar_patrulla()
		return SUCCESS

	return RUNNING
