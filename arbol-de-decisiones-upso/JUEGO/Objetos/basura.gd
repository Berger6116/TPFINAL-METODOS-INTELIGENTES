extends Node2D
class_name Basura
var resistencia: int

func _ready() -> void:
	resistencia = 4*randi_range(1,16)
	setear_sprite(resistencia)

func setear_sprite(n:int):
	var img = (n) % 4
	$Sprite2D.frame = img

func consumir(quita:int):
	resistencia -=quita
	$ParticulasConsumicion.restart()
	if resistencia <= 0:
		queue_free()
