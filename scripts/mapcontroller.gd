class_name MapController

extends TileMapLayer

const MAP_SIZE = 128
const RESOURCE_AVAILABILITY = 0.15
const BORDER_THICKNESS = 8
const NOISE_SCALE = 0.08
const ISLAND_RADIUS_FACTOR = 0.95

const TERRAIN_SET = 0  # Your terrain set index
const SEA_TERRAIN   = 0  # Sea terrain index within the set
const GROUND_TERRAIN = 1  # Ground terrain index within the set

var noise := FastNoiseLite.new()
var camp : Node2D

var fire_template = preload("res://prefabs/Fire.tscn")
var tree_template = preload("res://prefabs/Tree.tscn")
var fern_template = preload("res://prefabs/Fern.tscn")

func _ready():
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = NOISE_SCALE
	
	camp = get_node("/root/Game Scene/Camp")

	generate_island()
	set_spawn()

func generate_island():
	var center = Vector2(MAP_SIZE / 2.0, MAP_SIZE / 2.0)
	var max_radius = (MAP_SIZE / 2.0) * ISLAND_RADIUS_FACTOR

	var sea_cells: Array[Vector2i] = []
	var ground_cells: Array[Vector2i] = []

	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			var tile_pos = Vector2i(x, y)

			if x < BORDER_THICKNESS or x >= MAP_SIZE - BORDER_THICKNESS \
			or y < BORDER_THICKNESS or y >= MAP_SIZE - BORDER_THICKNESS:
				sea_cells.append(tile_pos)
				continue

			var dist = Vector2(x, y).distance_to(center) / max_radius
			var n = (noise.get_noise_2d(x, y) + 1.0) / 2.0
			var value = n - dist

			if value > 0.0:
				ground_cells.append(tile_pos)
			else:
				sea_cells.append(tile_pos)

	# Paint all sea tiles together so terrain autotiling connects correctly
	print("PAINTING {0} SEA TILES".format([sea_cells.size()]))
	set_cells_terrain_connect(sea_cells, TERRAIN_SET, SEA_TERRAIN, false)
	
	# Paint ground on top — later call wins for overlapping cells
	print("PAINTING {0} GROUND TILES".format([ground_cells.size()]))
	set_cells_terrain_connect(ground_cells, TERRAIN_SET, GROUND_TERRAIN, false)

	var resource_cells = get_random_subset(ground_cells, RESOURCE_AVAILABILITY)
	for cell in resource_cells:
		match randi_range(1, 10):
			1, 2, 3, 4, 5, 6:
				add_fern(map_to_local(cell))
			7,8,9,10:
				add_tree(map_to_local(cell))

func set_spawn():
	var safe_area : int = 2
	var best_tile = find_spawn_tile()
	var spawn_cells: Array[Vector2i] = []
	for x in range(best_tile.x-safe_area, best_tile.x+safe_area):
		for y in range(best_tile.y-safe_area, best_tile.y+safe_area):
			spawn_cells.append(Vector2(x, y))
	
	set_cells_terrain_connect(spawn_cells, TERRAIN_SET, GROUND_TERRAIN, false)
	camp.position = map_to_local(best_tile)

func find_spawn_tile() -> Vector2i:
	for x in range((MAP_SIZE - BORDER_THICKNESS) / 2, MAP_SIZE - BORDER_THICKNESS):
		var pos = Vector2i(x, MAP_SIZE / 2)
		var tile_data = get_cell_tile_data(pos)
		if tile_data and tile_data.get_terrain() == SEA_TERRAIN:
			return pos
	return Vector2i(MAP_SIZE / 2, MAP_SIZE / 2)  # fallback

func get_random_subset(cells: Array[Vector2i], percent: float) -> Array[Vector2i]:
	var shuffled = cells.duplicate()
	shuffled.shuffle()
	var count = int(shuffled.size() * percent)
	return shuffled.slice(0, count)

func add_tree(location: Vector2) -> void:
	var tree = tree_template.instantiate()
	tree.position = location
	add_child(tree)
	
func add_fern(location: Vector2) -> void:
	var fern = fern_template.instantiate()
	fern.position = location
	add_child(fern)
	
func add_campfire(location: Vector2) -> void:
	var new_fire = fire_template.instantiate()
	new_fire.fuel_available = 100
	new_fire.global_position = location
	add_child(new_fire)
