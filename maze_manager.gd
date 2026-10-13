extends Node2D

const GRID_SIZE := 5
const CELL_SIZE := 200.0
const BOARD_CENTER := Vector2(960, 540)

# Mode debug: ganti ke false jika ingin dinding benar-benar tersembunyi dari player
@export var show_walls_debug := false # Ubah jadi false

# Struktur Data Dinding Horizontal dan Vertikal
# Dinding Horizontal (Antara baris y dan y+1): Matriks 5x4
# Dinding Vertikal (Antara kolom x dan x+1): Matriks 4x5
var horizontal_walls := [
	[true,  false, true,  false, false], # Baris 0 ke 1
	[false, true,  false, true,  true],  # Baris 1 ke 2
	[false,  false, true,  true, false], # Baris 2 ke 3
	[false, true,  false, false,  false]  # Baris 3 ke 4
]

var vertical_walls := [
	[false, true,  false, true],  # Kolom 0
	[true,  false, false,  false], # Kolom 1
	[false, false,  false, true],  # Kolom 2
	[true,  false, true,  true], # Kolom 3
	[false, true,  false, false]  # Kolom 4
]

var is_game_started := false

func _ready() -> void:
	# Saat pertama kali buka, dinding Wajib kelihatan untuk dihafalkan
	show_walls_debug = true
	queue_redraw()

func start_game() -> void:
	show_walls_debug = false
	revealed_walls.clear() # Bersihkan dinding ter-spill dari sesi sebelumnya
	queue_redraw()

# Menampung koordinat dinding yang sudah pernah ditabrak
# Format data: {"type": "h"/"v", "pos": Vector2i(y, x)}
var revealed_walls := []

func _draw() -> void:
	# if not show_walls_debug:
	# 	return
		
	var offset = Vector2(GRID_SIZE - 1, GRID_SIZE - 1) * CELL_SIZE / 2.0
	var wall_color := Color(1.0, 0.2, 0.2, 0.9)
	var wall_thickness := 12.0 # Dipertebal dari 6 -> 12
	var wall_length := 105.0    # Diperpanjang dari 30 -> 90

	# 1. Jika dalam mode debug (fase preview awal), gambar SELURUH dinding
	if show_walls_debug:
		_draw_all_walls(offset, wall_color, wall_thickness, wall_length)
		return

	# 2. Jika dalam mode gameplay biasa, HANYA gambar dinding yang ter-SPILL
	for wall in revealed_walls:
		var y = wall.pos.x
		var x = wall.pos.y
		
		if wall.type == "h":
			var pos_x = (BOARD_CENTER.x - offset.x) + (x * CELL_SIZE)
			var pos_y = (BOARD_CENTER.y - offset.y) + (y * CELL_SIZE) + (CELL_SIZE / 2.0)
			draw_line(Vector2(pos_x - wall_length, pos_y), Vector2(pos_x + wall_length, pos_y), wall_color, wall_thickness)
		elif wall.type == "v":
			var pos_x = (BOARD_CENTER.x - offset.x) + (x * CELL_SIZE) + (CELL_SIZE / 2.0)
			var pos_y = (BOARD_CENTER.y - offset.y) + (y * CELL_SIZE)
			draw_line(Vector2(pos_x, pos_y - wall_length), Vector2(pos_x, pos_y + wall_length), wall_color, wall_thickness)

func _draw_all_walls(offset: Vector2, color: Color, thickness: float, length: float) -> void:
	for y in range(GRID_SIZE - 1):
		for x in range(GRID_SIZE):
			if horizontal_walls[y][x]:
				var pos_x = (BOARD_CENTER.x - offset.x) + (x * CELL_SIZE)
				var pos_y = (BOARD_CENTER.y - offset.y) + (y * CELL_SIZE) + (CELL_SIZE / 2.0)
				draw_line(Vector2(pos_x - length, pos_y), Vector2(pos_x + length, pos_y), color, thickness)

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE - 1):
			if vertical_walls[y][x]:
				var pos_x = (BOARD_CENTER.x - offset.x) + (x * CELL_SIZE) + (CELL_SIZE / 2.0)
				var pos_y = (BOARD_CENTER.y - offset.y) + (y * CELL_SIZE)
				draw_line(Vector2(pos_x, pos_y - length), Vector2(pos_x, pos_y + length), color, thickness)

func has_wall_between(current: Vector2i, target: Vector2i) -> bool:
	var dir = target - current
	var hit = false
	var wall_type := ""
	var wall_coord := Vector2i.ZERO
	
	if dir == Vector2i(1, 0) and vertical_walls[current.y][current.x]:
		hit = true; wall_type = "v"; wall_coord = Vector2i(current.y, current.x)
	elif dir == Vector2i(-1, 0) and vertical_walls[current.y][target.x]:
		hit = true; wall_type = "v"; wall_coord = Vector2i(current.y, target.x)
	elif dir == Vector2i(0, 1) and horizontal_walls[current.y][current.x]:
		hit = true; wall_type = "h"; wall_coord = Vector2i(current.y, current.x)
	elif dir == Vector2i(0, -1) and horizontal_walls[target.y][current.x]:
		hit = true; wall_type = "h"; wall_coord = Vector2i(target.y, current.x)
		
	if hit:
		reveal_wall(wall_type, wall_coord)
		return true
		
	return false

func reveal_wall(type: String, coord: Vector2i) -> void:
	var data = {"type": type, "pos": coord}
	if not revealed_walls.has(data):
		revealed_walls.append(data)
		queue_redraw()


func reset_preview() -> void:
	show_walls_debug = true
	revealed_walls.clear()
	queue_redraw()
	
