extends Node2D
class_name HormigaGuerrera

#Externas
@export var velocidad:float = 60
@export var limite_pasos:int =2

#Internas
var direccion_actual: Vector2 = Vector2.DOWN
var punto_patrulla: Vector2 = Vector2.ZERO
var paso_patrulla_actual : int = 0
var objetivo_actual : PuntoPatrulla
var en_objetivo : bool = false


func buscar_nodo(nombre: String) -> Node2D:
	if get_tree().current_scene == null:
		return null
	return get_tree().current_scene.find_child(nombre, true, false) as Node2D

func buscar_nodos_en_grupo(nombre:String) -> Array[Node]:
	return get_tree().get_nodes_in_group(nombre)
	
func encontrar_paso_patrulla_correspondiente(paso:int) -> PuntoPatrulla:
	var Paso_Correspondiente : PuntoPatrulla = null
	var lista_Pasos : Array[Node] = buscar_nodos_en_grupo("PasoPatrulla")
	for index in lista_Pasos:
		if index is PuntoPatrulla:
			if index.Paso == paso:
				Paso_Correspondiente = index
	return Paso_Correspondiente
	
func mover_a_siguiente_paso(delta:float) -> void:
	en_objetivo = false
	objetivo_actual = encontrar_paso_patrulla_correspondiente(paso_patrulla_actual+1)
	if !en_objetivo : mover_a(objetivo_actual.global_position,delta)
	pass

func mover_a(position:Vector2, delta:float) -> void:
	cambiar_direccion_a(position)
	global_position += direccion_actual * velocidad * delta

func cambiar_direccion_a(nueva_direccion: Vector2) -> void:
	direccion_actual = nueva_direccion.normalized()
	rotation = direccion_actual.angle() - Vector2.DOWN.angle()
	
func patrullar(delta:float):

	buscar_nodo("")


func _on_cuerpo_area_entered(area) -> void:
	if area is PuntoPatrulla:
		if area == objetivo_actual:
			en_objetivo = true
		else:
			en_objetivo = false
	pass # Replace with function body.
