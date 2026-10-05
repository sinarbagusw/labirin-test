extends Node2D

@onready var play_button: Button = $playButton
@onready var maze_manager: Node2D = $MazeManager
@onready var player: Node2D = $Player
@onready var dots_drawer: Node2D = $DotsDrawer
@onready var lives_ui: Node2D = $LivesUI
@onready var status_label: Label = $Background/StatusLabel
@onready var timer_label: Label = $Background/LabelTimer

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed) #menyambungkan sinyal pressed dari tombol play ke fungsi _on_play_button_pressed
	reset_to_preview() # Tampilkan preview awal saat game pertama kali load

func show_game_over() -> void:
	status_label.text = "GAME OVER!\nNyawa Habis!"
	status_label.modulate = Color.RED
	status_label.show()
	timer_label.timer.stop() # Hentikan timer saat game over
	player.reset_position_player() # Reset posisi player ke awal

	await get_tree().create_timer(2.0).timeout
	status_label.hide() # Sembunyikan label status setelah 2 detik
	reset_to_preview() # Kembali ke preview awal setelah 2 detik

func show_victory() -> void:
	status_label.text = "SELAMAT!\nKamu Menang!"
	status_label.modulate = Color.GREEN
	status_label.show()
	timer_label.timer.stop() # Hentikan timer saat pemain menang
	player.reset_position_player() # Reset posisi player ke awal

	await get_tree().create_timer(2.0).timeout 
	status_label.hide() # Sembunyikan label status setelah 2 detik
	reset_to_preview() # Kembali ke preview awal setelah 2 detik

func _on_play_button_pressed() -> void: 
	play_button.hide() # Sembunyikan tombol saat game dimulai
	status_label.hide() # Sembunyikan label status saat game dimulai	
	maze_manager.start_game() # Sembunyikan dinding
	player.activate_player() # Munculkan player & izinkan gerak
	dots_drawer.reveal_goal() # Munculkan titik hijau finish
	lives_ui.set_active(true) # Tampilkan UI nyawa
	timer_label.start_timer() # Mulai timer countdown

func _on_timer_timeout() -> void:
	show_game_over() # Panggil fungsi game over saat timer habis

func reset_to_preview() -> void:
	play_button.show()           # Tampilkan kembali tombol Play
	maze_manager.reset_preview()   # Tampilkan dinding untuk dihafalkan
	dots_drawer.hide_goal()        # Sembunyikan titik finish
	lives_ui.set_active(false)      # Sembunyikan UI nyawa
	timer_label.reset_stopped_timer() # Reset timer ke 60 detik dan mulai countdown
	
