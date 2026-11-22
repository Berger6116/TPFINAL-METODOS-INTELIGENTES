extends Node2D
class_name Comida
var alimento: int
var enrutandose:bool = false

func _ready() -> void:
	alimento = randi_range(10,100)
	setear_sprite(alimento)

func setear_sprite(n:int):
	var img = (n - 10) % 40 * 2 + 1
	$Sprite2D.frame = img

func consumir(quita:int):
	alimento -=quita
	if alimento <= 0:
		queue_free()
