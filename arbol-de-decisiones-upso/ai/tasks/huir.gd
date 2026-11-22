@tool
extends BTAction

func _tick(delta: float) -> Status:
	return SUCCESS if agent.huir_de_enemigo(delta) else RUNNING
