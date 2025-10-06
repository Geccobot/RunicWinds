extends Sprite2D
class_name Cloud

@export var move_speed: float = 30.0        # Base pixels per second
@export var parallax_factor: float = 1.0    # Bigger = slower, for depth illusion
@export var reset_offset: float = 200.0     # How far off-screen to reset

var screen_width: float

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	
	# Randomize start position and movement variation
	position.x = randi_range(0, int(screen_width))
	position.y += randf_range(-10, 10)
	move_speed *= randf_range(0.8, 1.2)
	
	# Allow smooth subpixel movement
	set_as_top_level(true)

func _process(delta: float) -> void:
	# Move cloud to the RIGHT
	var new_x = position.x + (move_speed / parallax_factor) * delta
	
	# Smooth motion
	position.x = lerp(position.x, new_x, 0.5)
	
	# Loop when cloud goes off-screen
	if position.x > screen_width + reset_offset:
		position.x = -reset_offset
		position.y += randf_range(-10, 10)
