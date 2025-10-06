extends CharacterBody2D
class_name PushableBlock

@export var push_zone: Area2D	# Area where the block can move
@export var move_speed: float = 40.0
@export var tile_size: int = 32

var is_being_pushed: bool = false
var push_dir: Vector2 = Vector2.ZERO
var target_position: Vector2

func _ready() -> void:
	target_position = global_position

func _physics_process(delta: float) -> void:
	if is_being_pushed:
		var to_target = target_position - global_position
		if to_target.length() > 1.0:
			velocity = to_target.normalized() * move_speed
			move_and_slide()
		else:
			global_position = target_position
			velocity = Vector2.ZERO
			is_being_pushed = false

func try_push(direction: Vector2) -> void:
	print("trypush is being used")
	if is_being_pushed:
		return
	if direction == Vector2.ZERO:
		print("player isnt moving")
		return

	var next_pos := global_position + direction.normalized() * tile_size

	# OPTIONAL: if you set a push_zone, forbid moves outside it
	if push_zone and not _is_inside_zone(next_pos):
		print("block not in push zone")
		return

	# Only check for physics bodies, ignore areas
	var space_state := get_world_2d().direct_space_state
	var qp := PhysicsPointQueryParameters2D.new()
	qp.position = next_pos
	qp.collide_with_bodies = true
	qp.collide_with_areas = false   # <--- important
	qp.exclude = [self]


	var hits := space_state.intersect_point(qp) # expects at most 2 args
	if hits.size() > 0:
		print("something is in the way")
		# Something already occupies that spot, don't push
		return

	# Start moving toward the next tile
	target_position = next_pos
	push_dir = direction.normalized()
	is_being_pushed = true
	print("block should be moving")

# PuzzleElement-like helpers
func activate():
	queue_free() # example: disappear when "activated"

func deactivate():
	pass

func is_active() -> bool:
	return is_being_pushed

func _is_inside_zone(pos: Vector2) -> bool:
	if not push_zone:
		return true
	return push_zone.get_shape_owners().size() > 0 and push_zone.get_overlapping_bodies().has(self)


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_interactable(self)
		AlertManager.show_alert("Push")


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body is Player:
		body.set_interactable(null)
