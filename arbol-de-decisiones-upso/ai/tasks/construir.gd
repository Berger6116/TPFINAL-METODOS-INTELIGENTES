@tool
extends BTAction

@export var duracion: float = 2.0
var _tiempo: float = 0.0

func _enter() -> void:
	_tiempo = 0.0
	var cartel := agent.get_node_or_null("Label")
	if cartel:
		cartel.text = "Construyendo..."

func _tick(delta: float) -> Status:
	_tiempo += delta
	if _tiempo >= duracion:
		var hormigueros := agent.get_tree().get_nodes_in_group("hormiguero")
		if hormigueros.size() > 0:
			hormigueros[0].scale += Vector2(0.05, 0.05)
		return SUCCESS
	return RUNNING
