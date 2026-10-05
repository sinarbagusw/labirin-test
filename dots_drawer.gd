extends Node2D

const GRID_SIZE := 5
const CELL_SIZE := 200.0 # Jarak antar titik diperbesar untuk kotak 1000x1000
const BOARD_CENTER := Vector2(960, 540) # Tetap di tengah layar 1920x1080

@export var dot_radius := 14.0 # Lingkaran sedikit diperbesar agar proporsional
@export var dot_color := Color(0.2, 0.2, 0.2) # Warna titik abu-abu/hitam

var show_goal := false

func _draw() -> void:
	var offset = Vector2(GRID_SIZE - 1, GRID_SIZE - 1) * CELL_SIZE / 2.0
	
	# 1. Gambar 25 titik biasa
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var pos_x = (BOARD_CENTER.x - offset.x) + (x * CELL_SIZE)
			var pos_y = (BOARD_CENTER.y - offset.y) + (y * CELL_SIZE)
			draw_circle(Vector2(pos_x, pos_y), dot_radius, dot_color)
			
	# 2. Gambar Titik Finish HANYA jika show_goal == true
	if show_goal:
		var goal_grid_pos := Vector2i(4, 4)
		var goal2_grid_pos := Vector2i(2, 0)
		var goal_px = (BOARD_CENTER.x - offset.x) + (goal_grid_pos.x * CELL_SIZE)
		var goal_py = (BOARD_CENTER.y - offset.y) + (goal_grid_pos.y * CELL_SIZE)
		var goal2_px = (BOARD_CENTER.x - offset.x) + (goal2_grid_pos.x * CELL_SIZE)
		var goal2_py = (BOARD_CENTER.y - offset.y) + (goal2_grid_pos.y * CELL_SIZE)
		draw_circle(Vector2(goal_px, goal_py), 18.0, Color.GREEN)
		draw_circle(Vector2(goal2_px, goal2_py), 18.0, Color.GREEN)

func hide_goal() -> void:
	show_goal = false # Sembunyikan titik finish hijau lagi
	queue_redraw()

func reveal_goal() -> void:
	show_goal = true
	queue_redraw() # Refresh gambar agar titik finish muncul