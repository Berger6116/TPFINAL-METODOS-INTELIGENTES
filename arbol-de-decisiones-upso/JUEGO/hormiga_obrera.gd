extends Node2D

@onready var estado_label: Label = $Label

func huir() -> void:
	estado_label.text = "¡Huyendo de enemigos!"
	print("Obrera: ¡Huyendo de enemigos!")

func recolectar() -> void:
	estado_label.text = "Recolectando comida..."
	print("Obrera: Recolectando comida...")

func construir() -> void:
	estado_label.text = "Construyendo hormiguero..."
	print("Obrera: Construyendo hormiguero...")
