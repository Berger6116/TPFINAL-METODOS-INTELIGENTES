@tool
extends BTCondition

func _tick(_delta: float) -> Status:
	var comidas := agent.get_tree().get_nodes_in_group("comida")
	if comidas.size() > 0:
		blackboard.set_var("objetivo_comida", comidas[0])
		return SUCCESS
	return FAILURE
