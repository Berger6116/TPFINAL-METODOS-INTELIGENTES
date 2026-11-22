@tool
extends BTAction
class_name BTEsperar

@export var duracion: float = 2.0

var tiempo_transcurrido: float = 0.0

func _generate_name() -> String:
	return "Esperar %.1f segundos" % duracion

func _enter() -> void:
	tiempo_transcurrido = 0.0

func _tick(delta: float) -> Status:
	tiempo_transcurrido += delta

	if tiempo_transcurrido >= duracion:
		return SUCCESS

	return RUNNING
