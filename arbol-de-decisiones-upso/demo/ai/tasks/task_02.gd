
# Esta script solo cambia el texto del label del personaje que lo contiene
@tool
extends BTAction



# Opcional: define cómo se ve el nodo en el editor del BehaviorTree
func _generate_name() -> String:
	return "Patrullar!"

# Se ejecuta cada vez que el árbol entra a esta acción
func _enter() -> void:
	if agent is NPC_BASE:
		agent.patrullar()
	#if agent.has_method("patrullar"):
		#agent.patrullar()
	

# Se ejecuta en cada tick mientras la tarea está activa
func _tick(_delta: float) -> Status:
	return SUCCESS
