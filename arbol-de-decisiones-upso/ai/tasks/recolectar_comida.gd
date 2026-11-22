@tool
extends BTAction

func _tick(delta: float) -> Status:
	return SUCCESS if agent.ir_a_comida(delta) else RUNNING
