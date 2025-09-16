extends Node

signal gesture_performed(pattern: Array)

var gesture_points: Array = []
var is_recording_gesture: bool = false
const MIN_GESTURE_DISTANCE := 50.0

# These will be set up after the scene tree is ready
var gesture_trail: Line2D
var panel_container: Control

func configure(panel: PanelContainer, trail: Line2D):
	panel_container = panel
	gesture_trail = trail

func start_gesture():
	if not gesture_trail or not panel_container:
		print("⚠️ GestureManager not configured with UI nodes.")
		return
	gesture_points.clear()
	gesture_trail.clear_points()
	is_recording_gesture = true
	gesture_trail.visible = true

func update_gesture():
	if not is_recording_gesture:
		return
	var screen_pos = get_viewport().get_mouse_position()
	if gesture_points.is_empty() or gesture_points[-1].distance_to(screen_pos) >= MIN_GESTURE_DISTANCE:
		gesture_points.append(screen_pos)
		
		# Convert global to local relative to the panel
		var panel_top_left = panel_container.get_global_rect().position
		var local_pos = screen_pos - panel_top_left
		
		gesture_trail.add_point(local_pos)



func end_gesture():
	if not is_recording_gesture:
		return
	is_recording_gesture = false
	gesture_trail.visible = false
	if gesture_points.size() < 3:
		print("❌ Too few points for a valid gesture.")
		return
	var pattern = simplify_gesture(gesture_points)
	emit_signal("gesture_performed", pattern)

func simplify_gesture(points: Array) -> Array:
	var result = []
	for i in range(1, points.size()):
		var delta = points[i] - points[i - 1]
		delta.y *= -1
		var angle = delta.angle()
		var dir = quantize_angle(angle)
		if result.is_empty() or result[-1] != dir:
			result.append(dir)
	return result

func quantize_angle(angle: float) -> String:
	angle = wrapf(angle, -PI, PI)
	if angle < -7 * PI / 8 or angle >= 7 * PI / 8:
		return "left"
	elif angle < -5 * PI / 8:
		return "down-left"
	elif angle < -3 * PI / 8:
		return "down"
	elif angle < -PI / 8:
		return "down-right"
	elif angle < PI / 8:
		return "right"
	elif angle < 3 * PI / 8:
		return "up-right"
	elif angle < 5 * PI / 8:
		return "up"
	elif angle < 7 * PI / 8:
		return "up-left"
	return "right"
