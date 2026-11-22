@tool
extends BTCondition

func _tick(_delta: float) -> Status:
	if agent is not HormigaGuerrera: return FAILURE
	if agent is HormigaGuerrera:
		if agent.hay_enemigo_cerca() : 
			#print("Se encontraron enemigos")
			return SUCCESS
	return FAILURE
