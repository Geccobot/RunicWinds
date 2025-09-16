extends PointLight2D
class_name Lantern

@onready var lantern_sfx: AudioStreamPlayer2D = $lanternSFX
var tween: Tween
var is_lit = false

func _ready() -> void:
	energy = 0.0
	visible = false
	tween = create_tween()

func toggle() -> void:
	is_lit = not is_lit
	if is_lit:
		turn_on()
	else:
		turn_off()

func turn_on() -> void:
	visible = true
	_kill_tween()
	lantern_sfx.play()
	tween = create_tween()
	tween.tween_property(self, "energy", 1.0, 0.5)

func turn_off() -> void:
	_kill_tween()
	lantern_sfx.play()
	tween = create_tween()
	tween.tween_property(self, "energy", 0.0, 0.5)
	tween.tween_callback(Callable(self, "_hide"))

func _hide() -> void:
	visible = false

func _kill_tween() -> void:
	if tween and tween.is_valid():
		tween.kill()
