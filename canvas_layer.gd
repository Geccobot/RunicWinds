extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var sfx: AudioStreamPlayer2D = $SFX

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SceneTransition.animate_entrance()
	timer.start()
	sfx.play()
	
func _on_timer_timeout() -> void:
	SceneTransition.animate_exit("res://Scenes/UI_Scenes/Main_menu/title_screen.tscn", "down")
