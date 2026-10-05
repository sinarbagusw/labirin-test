extends Label

@onready var timer: Timer = $Timer

#durasi timer dalam detik
var timer_duration = 60.0

# Called when the node enters the scene tree for the first time.
func start_timer() -> void:
	timer.wait_time = timer_duration
	timer.start()
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	#

func reset_stopped_timer() -> void:
	timer.stop()
	text = "00:10" # Reset label ke 1 menit


func _process(_delta: float) -> void:
	if not timer.is_stopped():
		var time_left = timer.time_left
		var minute = int(time_left) / 60
		var second = int(time_left) % 60
		
		# Properti 'text' langsung milik Label ini sendiri
		text = "%02d:%02d" % [minute, second]
