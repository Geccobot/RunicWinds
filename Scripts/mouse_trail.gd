extends Line2D

@export var max_points: int = 10 # Maximum number of points in the trail
@export var max_trail_length: float = 100.0 # Maximum distance between points


var total_distance: float = 0.0

func _ready():
	print("mouse trail ready")
	clear_points()

func _process(delta):
	var current_mouse_position = get_viewport().get_mouse_position()

	if points.is_empty():
		add_point(current_mouse_position)
		points.append(current_mouse_position)

			# Keep trail length within max_points limit
		if points.size() > max_points:
			remove_point(0)
			points.remove_at(0)
