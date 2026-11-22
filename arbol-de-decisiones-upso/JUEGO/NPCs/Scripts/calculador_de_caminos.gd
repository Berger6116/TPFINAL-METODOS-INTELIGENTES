
extends Node2D
class_name CalculadorCaminos

@export var capa_mapa: TileMapLayer

var astar: AStarGrid2D


func _ready() -> void:
	crear_grilla()


func crear_grilla() -> void:
	astar = AStarGrid2D.new()

	astar.region = capa_mapa.get_used_rect().grow(1)
	astar.cell_size = capa_mapa.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES

	astar.update()

	for celda in capa_mapa.get_used_cells():
		var datos: TileData = capa_mapa.get_cell_tile_data(celda)

		if datos != null and datos.get_collision_polygons_count(0) > 0:
			astar.set_point_solid(celda, true)


func obtener_camino(origen: Vector2, destino: Vector2) -> Array[Vector2]:
	var inicio: Vector2i = capa_mapa.local_to_map(capa_mapa.to_local(origen))
	var final: Vector2i = capa_mapa.local_to_map(capa_mapa.to_local(destino))

	if astar.is_point_solid(inicio) or astar.is_point_solid(final):
		return []

	var recorrido = astar.get_id_path(inicio, final)
	var camino: Array[Vector2] = []

	for celda in recorrido:
		camino.append(capa_mapa.to_global(capa_mapa.map_to_local(celda)))

	return camino
