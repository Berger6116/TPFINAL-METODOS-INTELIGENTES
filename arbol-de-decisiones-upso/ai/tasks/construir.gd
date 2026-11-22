@tool
extends BTAction

func _tick(delta: float) -> Status:
	agent.construir_hormiguero(delta)
	return SUCCESS
