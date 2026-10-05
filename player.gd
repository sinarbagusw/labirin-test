
extends Node2D

# Konfigurasi Grid (Harus sama dengan DotsDrawer)
const GRID_SIZE := 5
const CELL_SIZE := 200.0
const BOARD_CENTER := Vector2(960, 540)

# Posisi player dalam koordinat Matriks (X: 0..4, Y: 0..4)
# Kita mulai dari pojok kiri atas (0, 0)
var grid_pos := Vector2i(0, 4) #grid post untuk player, default di pojok kiri bawah
const GOAL_POS1 := Vector2i(4, 4)
const GOAL_POS2 := Vector2i(2, 0)
const MAX_LIVES := 3

@onready var maze_manager: Node2D = $"../MazeManager"
@onready var main_game = $".."
@onready var lives_ui: Node2D = $"../LivesUI"

var is_active := false
var current_lives := MAX_LIVES
var sum_target = 0

func _ready() -> void:
	hide() # Sembunyikan visual player saat pertama kali load
	update_player_position()

func _draw() -> void:
	# Gambar Player berupa lingkaran merah berdiameter agak besar
	draw_circle(Vector2.ZERO, 24.0, Color.RED)

func activate_player() -> void:
	is_active = true
	current_lives = MAX_LIVES
	lives_ui.update_lives(current_lives) #reset nyawa di UI
	grid_pos = Vector2i(0, 4) #grid post untuk player, default di pojok kiri bawah
	update_player_position()
	show() # Tampilkan player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		move(Vector2i(1, 0))
	elif event.is_action_pressed("ui_left"):
		move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_down"):
		move(Vector2i(0, 1))
	elif event.is_action_pressed("ui_up"):
		move(Vector2i(0, -1))


func update_player_position() -> void:
	var offset = Vector2(GRID_SIZE - 1, GRID_SIZE - 1) * CELL_SIZE / 2.0
	var pos_x = (BOARD_CENTER.x - offset.x) + (grid_pos.x * CELL_SIZE)
	var pos_y = (BOARD_CENTER.y - offset.y) + (grid_pos.y * CELL_SIZE)
	
	# Pindahkan posisi node Player di layar
	position = Vector2(pos_x, pos_y)
	queue_redraw() # Refresh gambar jika ada perubahan

func move(dir: Vector2i) -> void:
	if not is_active:
		return
	var target_pos = grid_pos + dir
	if target_pos.x >= 0 and target_pos.x < GRID_SIZE and target_pos.y >= 0 and target_pos.y < GRID_SIZE:
		if maze_manager.has_wall_between(grid_pos, target_pos):
			handle_wall_collision()
		else:
			grid_pos = target_pos
			update_player_position()
			if grid_pos == GOAL_POS2 and sum_target < 1:
				sum_target += 1
				print("point=", sum_target)
			
			elif grid_pos == GOAL_POS1 and sum_target >= 1:
				reset_position_player()
				trigger_victory()
				


func handle_wall_collision() -> void:
	current_lives -= 1
	lives_ui.update_lives(current_lives)
	print("NABRAK! Nyawa tersisa: ", current_lives)
	
	if current_lives <= 0:
		print("GAME OVER! Nyawa Habis.")
		trigger_game_over()
	else:
		# Player dikembalikan ke posisi awal (0,0) tapi dinding yang ditabrak TETAP TERLIHAT
		grid_pos = Vector2i(0, 4) #grid post untuk player, default di pojok kiri bawah
		update_player_position()

func reset_position_player() -> void:
	is_active = false
	await get_tree().create_timer(2.0).timeout #tunggu setengah detik sebelum reset posisi player
	grid_pos = Vector2i(0, 4) #grid post untuk player, default di pojok kiri bawah
	update_player_position()

func trigger_victory() -> void:
	print("WINNER! KAMU BERHASIL KELUAR DARI LABIRIN!")
	is_active = false #menyatakan 
	hide() # Sembunyikan player lagi
	reset_position_player() # Reset posisi player ke awal
	main_game.show_victory() # Panggil fungsi reset di Main

func trigger_game_over() -> void:
	print("TABRAKAN! GAME OVER!")
	is_active = false
	hide()
	reset_position_player() 
	# Logika reset posisi player ke awal
	main_game.show_game_over() # Panggil fungsi reset di Main
