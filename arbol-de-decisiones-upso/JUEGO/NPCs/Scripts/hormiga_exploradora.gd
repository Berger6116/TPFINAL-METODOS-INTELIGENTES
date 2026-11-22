extends Node2D
class_name hormiga_exploradora

#Datos del mundo
var hormiguero_actual:Node2D = null
var ubicacion_hormiguero: Vector2

#Datos propios
@export var velocidad:float = 60
@export var tiempo_minimo_cambio: float = 5.0
@export var tiempo_maximo_cambio: float = 10.0

@onready var detector_de_obstaculos: RayCast2D = $Detector
@onready var vision:Area2D = $AreaVision

signal objeto_detectado(String)

#Datos temporales
var direccion_actual: Vector2 = Vector2.DOWN
var tiempo_cambio_restante: float = 0.0
var ubicacion_objeto: Vector2
var camino_al_hormiguero: Path2D
var objeto_encontrado: Node = null
#Datos de navegacion (wander) temporales
var obstaculo_detectado: bool = false
var direcciones_disponibles: Array[Vector2] = []
var tiempo_espera_obstaculo: float = 2.0

func _ready() -> void:
	tiempo_cambio_restante = randf_range(tiempo_minimo_cambio, tiempo_maximo_cambio)
	hormiguero_actual = get_tree().current_scene.find_child("Hormiguero",true,false)


#region Movimiento


func cambiar_direccion() -> void:
	var angulo = randf_range(0.0, TAU)
	direccion_actual = Vector2.DOWN.rotated(angulo)
	rotation = direccion_actual.angle() - Vector2.DOWN.angle()
	tiempo_cambio_restante = randf_range(tiempo_minimo_cambio,tiempo_maximo_cambio)

func deambular (delta) -> void:
	tiempo_cambio_restante -= delta
	if tiempo_cambio_restante <= 0.0:
		cambiar_direccion()
	global_position += direccion_actual * velocidad * delta

func comprobar_obstaculo() -> bool:
	detector_de_obstaculos.force_raycast_update()
	obstaculo_detectado = detector_de_obstaculos.is_colliding()
	return obstaculo_detectado

func obtener_direcciones_disponibles() -> Array[Vector2]:
	var direcciones: Array[Vector2] = []
	var angulo_inicial = randf_range(0.0, TAU)
	for intento in range(6):
		var angulo = angulo_inicial + (TAU / 6.0) * intento
		var direccion = Vector2.DOWN.rotated(angulo)
		detector_de_obstaculos.target_position = direccion * 120.0
		detector_de_obstaculos.force_raycast_update()
		if not detector_de_obstaculos.is_colliding():
			direcciones.append(direccion)
	detector_de_obstaculos.target_position = Vector2.DOWN * 120.0
	return direcciones

func cambiar_direccion_a(nueva_direccion: Vector2) -> void:
	direccion_actual = nueva_direccion.normalized()
	rotation = direccion_actual.angle() - Vector2.DOWN.angle()
	tiempo_cambio_restante = randf_range(tiempo_minimo_cambio, tiempo_maximo_cambio)
#endregion

func encontrar_algo(cosa) -> void:
	#Al encontrar algo en su área de visión se fija que es y duevuelve el tipo.
	if is_instance_valid(objeto_encontrado):
		return
	var objeto = cosa.get_parent()
	if objeto is Basura:
		objeto_encontrado = objeto
		print("Encontré basura")
		objeto_detectado.emit("Basura")
	elif objeto is Comida:
		objeto_encontrado = objeto
		print("Encontré comida")
		objeto_detectado.emit("Comida")

func buscar_camino_al_hormiguero() -> bool:
	#Busca si hay un camino al hormiguero.
	return false

func comprobar_cercania_al_hormiguero() -> Array:
	#Se fija si la hormiga está dentro del área de influencia del hormiguero.
	if is_instance_valid(hormiguero_actual):
		var distancia_maxima: float = hormiguero_actual.limite_region
		ubicacion_hormiguero = hormiguero_actual.global_position
		var distancia_actual: float = global_position.distance_to(ubicacion_hormiguero)

		return [distancia_actual <= distancia_maxima, ubicacion_hormiguero]

	return [false, Vector2.ZERO]

#func ir_al_hormiguero(ubicacion_hormiguero) -> Path2D:
	#Crea el path al hasta el hormiguero comprobando los obstaculos y deja el path creado vinculado al hormiguero para que luego lo sigan las obreras.
