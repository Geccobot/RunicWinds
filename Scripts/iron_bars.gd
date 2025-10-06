extends PuzzleElement

@onready var iron_bars: AnimatedSprite2D = $StaticBody2D/IronBars
@onready var iron_bars_sfx: AudioStreamPlayer2D = $IronBarsSFX
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var start_open: bool = false  # configurable in the editor

var _is_open := false

func _ready() -> void:
	if start_open:
		activate()
	else:
		deactivate()

func activate():
	_is_open = true
	iron_bars.play("open")
	iron_bars_sfx.play()
	$StaticBody2D.set_deferred("collision_layer", 0)
	$StaticBody2D.set_deferred("collision_mask", 0)

func deactivate():
	_is_open = false
	iron_bars.play("close")
	iron_bars_sfx.play()
	$StaticBody2D.set_deferred("collision_layer", 1) # reset to original
	$StaticBody2D.set_deferred("collision_mask", 1)

func is_active() -> bool:
	return _is_open
