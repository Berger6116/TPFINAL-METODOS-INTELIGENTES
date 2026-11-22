extends Node2D
class_name HormigaGuerrera

#Externas
@export var velocidad:float = 60
@export var limite_pasos:int =2
@export var rango_enemigo: float = 150.0

#Internas
var direccion_actual: Vector2 = Vector2.DOWN
var punto_patrulla: Vector2 = Vector2.ZERO
var paso_patrulla_actual : int = 0
var objetivo_actual : Node2D
var en_objetivo : bool = false


func cambiar_label(texto:String)->void:
	$AccionObjeto.text = texto

func buscar_nodo(nombre: String) -> Node2D:
	if get_tree().current_scene == null:
		return null
	return get_tree().current_scene.find_child(nombre, true, false) as Node2D

func buscar_nodos_en_grupo(nombre:String) -> Array[Node]:
	return get_tree().get_nodes_in_group(nombre)
	
func encontrar_paso_patrulla_correspondiente(paso:int) -> PuntoPatrulla:
	var Paso_Correspondiente : PuntoPatrulla
	var lista_Pasos : Array[Node] = buscar_nodos_en_grupo("PasoPatrulla")
	#print("Buscando paso: ", paso, " | Nodos encontrados: ", lista_Pasos.size())
	for nodo in lista_Pasos:
		if nodo is PuntoPatrulla:
			if nodo.Paso == paso:
				Paso_Correspondiente = nodo
	return Paso_Correspondiente
	
@export var margen_llegada: float = 10.0

func preparar_paso_patrulla() -> void:
	en_objetivo = false
	objetivo_actual = encontrar_paso_patrulla_correspondiente(paso_patrulla_actual)


func avanzar_paso_patrulla() -> void:
	paso_patrulla_actual += 1
	if paso_patrulla_actual > limite_pasos:
		paso_patrulla_actual = 0


func patrullar(delta: float) -> void:
	if objetivo_actual == null:
		return
	var distancia := global_position.distance_to(objetivo_actual.global_position)
	if distancia <= margen_llegada:
		en_objetivo = true
		return
	mover_a(objetivo_actual.global_position, delta)

func mover_a(objetivo_pos: Vector2, delta: float) -> void:
	var vector_hacia_objetivo := objetivo_pos - global_position
	cambiar_direccion_a(vector_hacia_objetivo)
	global_position += direccion_actual * velocidad * delta

func cambiar_direccion_a(nueva_direccion: Vector2) -> void:
	if nueva_direccion == Vector2.ZERO:
		return
	direccion_actual = nueva_direccion.normalized()
	rotation = direccion_actual.angle() - Vector2.DOWN.angle()
	
func mover_a_siguiente_paso(delta:float) -> void:
	objetivo_actual = encontrar_paso_patrulla_correspondiente(paso_patrulla_actual)
	if !en_objetivo : mover_a(objetivo_actual.global_position,delta)
	pass

func _on_cuerpo_area_entered(area) -> void:
	if area is PuntoPatrulla:
		if area == objetivo_actual:
			en_objetivo = true
		else:
			en_objetivo = false
	pass # Replace with function body.
	
func hay_enemigo_cerca() -> bool:
	var enemigos : Array[Node] = buscar_nodos_en_grupo("Enemigo")
	for node in enemigos:
		if global_position.distance_to(node.global_position) <= rango_enemigo:
			objetivo_actual = node
			return true
	return false

func atacar(delta:float):
	mover_a(objetivo_actual.global_position,delta)

func ir_hacia_enemigo():
	print("Yendo hacia enemigo")

	
