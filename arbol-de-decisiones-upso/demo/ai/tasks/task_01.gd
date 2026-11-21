
# Esta script solo cambia el texto del label del personaje que lo contiene
@tool
extends BTAction

@export var mensaje: String = "Atacando..."


# Opcional: define cómo se ve el nodo en el editor del BehaviorTree
func _generate_name() -> String:
	return "Set_Estado (%s)" % mensaje


# Se ejecuta cada vez que el árbol entra a esta acción
func _enter() -> void:
	cambiar_estado()
		
func cambiar_estado() -> void:
	if agent.has_method("set_estado"):
		agent.set_estado(mensaje)


# Se ejecuta en cada tick mientras la tarea está activa
func _tick(_delta: float) -> Status:
	return SUCCESS
