@tool
extends BTAction
class_name BTDDeambular

func _generate_name() -> String:
	return "Deambular"

func _tick(delta: float) -> Status:
	if not is_instance_valid(agent):
		return FAILURE

	if not agent.has_method("deambular"):
		return FAILURE

	agent.call("deambular", delta)

	return RUNNING
