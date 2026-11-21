extends Node2D
class_name NPC_BASE

@onready var estado_label: Label = $Label

func set_estado(texto: String) -> void:
	estado_label.text = texto

func patrullar():
	estado_label.text = "Patrullando!!!"
	print('patrullando por codigo')
