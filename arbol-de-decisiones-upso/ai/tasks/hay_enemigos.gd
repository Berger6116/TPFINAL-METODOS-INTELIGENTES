@tool
extends BTCondition

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.hay_enemigo_cerca() else FAILURE
