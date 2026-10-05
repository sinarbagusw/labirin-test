extends Node2D

const BOX_SIZE := Vector2(100, 100) #mengatur ukuran kotak nyawa
const BOX_SPACING := 40.0 #mengatur jarak antar kotak nyawa
const START_POS := Vector2(30, 70) # Position di pojok kiri atas layar

var lives := 3
var is_visible := false

func _draw() -> void:
	if not is_visible:
		return
		
	# Gambar kotak sebanyak jumlah nyawa yang tersisa
	for i in range(lives):
		var x_pos = START_POS.x + i * (BOX_SIZE.x + BOX_SPACING)
		var rect = Rect2(Vector2(x_pos, START_POS.y), BOX_SIZE)
		draw_rect(rect, Color.RED)

func update_lives(count: int) -> void:
	lives = count
	queue_redraw()

func set_active(active: bool) -> void:
	is_visible = active
	queue_redraw()