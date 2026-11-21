extends Node2D
class_name gestor_hormiguero

@export var comida:int = 50
@export var obreras:int = 0
@export var guerreras:int = 0
@export var exploradoras:int = 0
@export var integridad:int = 100

func _process(delta: float) -> void:
	if comida >0:
		comida -= obreras + 2*exploradoras + 3* guerreras
		if comida > 12:
			obreras += 1
			exploradoras += 1
			guerreras +=1
			#spawnear_hormigas()
	else:
		integridad -= 1
