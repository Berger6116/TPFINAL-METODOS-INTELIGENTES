@tool
extends BTCondition

func _tick(_delta: float) -> Status:
	return SUCCESS if agent.hay_comida() else FAILURE
