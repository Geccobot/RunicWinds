extends Area2D
class_name Hitbox
@onready var stats: Stats = $"../Resources/Stats"

@export var damage: int = 10
@export var Boxowner: Node = null  # Set by Player/Enemy in _ready

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Track overlapping combatants
var _candidates: Array[Node] = []
var current_target: Node = null

func _ready() -> void:
	add_to_group("hitbox")
	monitoring = false                # off by default; enable during attack window
	if collision_shape:
		collision_shape.disabled = true

	# Make sure these signals are connected in the editor or here in code:
	# connect("body_entered", _on_body_entered)
	# connect("body_exited", _on_body_exited)

func enable() -> void:
	monitoring = true
	if collision_shape:
		collision_shape.disabled = false

func disable() -> void:
	monitoring = false
	if collision_shape:
		collision_shape.disabled = true
	_candidates.clear()
	current_target = null

func _on_body_entered(body: Node) -> void:
	var root := _find_combat_root(body)
	if root == null:
		return
	if root == Boxowner:
		return  # don't target self
	if _candidates.has(root):
		return
	_candidates.append(root)
	_pick_target()

func _on_body_exited(body: Node) -> void:
	var root := _find_combat_root(body)
	if root == null:
		return
	_candidates.erase(root)
	_pick_target()

func _pick_target() -> void:
	# Choose closest candidate to this hitbox
	if _candidates.is_empty():
		current_target = null
		return
	var closest := _candidates[0]
	var best_d := INF
	for c in _candidates:
		var d = global_position.distance_to(c.global_position)
		if d < best_d:
			best_d = d
			closest = c
	current_target = closest

func _find_combat_root(n: Node) -> Node:
	# Walk up parents until we find a node that has a "Combat" child
	var p := n
	while p:
		if p.has_node("Combat"):
			return p
		p = p.get_parent()
	return null
