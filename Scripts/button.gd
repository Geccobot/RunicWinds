extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $StaticBody2D/AnimatedSprite2D
@onready var activate_sfx: AudioStreamPlayer2D = $activateSFX
@onready var area: Area2D = $Area2D
@onready var light: PointLight2D = $PointLight2D

@export var targets: Array[NodePath] = []

# Modes
@export var toggle_mode: bool = false       # Tap → stays active until pressed again
@export var hold_mode: bool = false         # Only stays active while standing on it
@export var timed_mode: bool = false        # Activates for a set duration
@export var timed_duration: float = 2.0     # Seconds active in timed mode

var is_pressed := false
var timer: Timer

func _ready():
	# Create a timer if using timed mode
	if timed_mode:
		timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(_on_timed_expire)

func _trigger_targets():
	for path in targets:
		var node = get_node_or_null(path)
		if node and node is PuzzleElement:
			if toggle_mode:
				node.toggle()
			else:
				node.activate()

func _release_targets():
	for path in targets:
		var node = get_node_or_null(path)
		if node and node is PuzzleElement:
			node.deactivate()

# When the timer runs out (timed mode only)
func _on_timed_expire():
	print("Button released (timed mode)")
	is_pressed = false
	animated_sprite_2d.play("off")
	light.visible = false
	_release_targets()

# When something enters (Player or PushableBlock, both must be in "button_activators" group)
func _on_activate_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("button_activators"):
		if not is_pressed or toggle_mode or hold_mode or timed_mode:
			print("Button pressed by ", body)
			is_pressed = true
			animated_sprite_2d.play("activate")
			activate_sfx.play()
			_trigger_targets()

			# Timed mode → start countdown
			if timed_mode and timer:
				timer.start(timed_duration)

# When leaving (only matters for hold mode)
func _on_activate_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("button_activators") and hold_mode:
		print("Button released (hold mode) by", body)
		is_pressed = false
		animated_sprite_2d.play("deactivate")
		_release_targets()
