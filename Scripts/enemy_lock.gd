extends PuzzleElement
class_name EnemyLock

@export var enemy_paths: Array[NodePath] = []     # Drag enemies in manually
@export var enemy_group: String = ""              # Or specify a group name
@export var targets: Array[NodePath] = []         # What this unlocks (gates, bridges, etc.)
@onready var success_sfx: AudioStreamPlayer = $SuccessSFX

var enemies: Array = []
var _is_active: bool = false

func _ready():
	# Collect enemies from explicit NodePaths
	for path in enemy_paths:
		var e = get_node_or_null(path)
		if e:
			_add_enemy(e)

	# Or collect by group
	if enemy_group != "":
		for e in get_tree().get_nodes_in_group(enemy_group):
			_add_enemy(e)

	print("EnemyLock tracking:", enemies.size(), "enemies")

func _add_enemy(e: Node) -> void:
	if enemies.has(e): 
		return
	enemies.append(e)
	# Connect to the enemy's exit, binding the enemy node so we can erase it
	if not e.is_connected("tree_exited", Callable(self, "_on_enemy_removed").bind(e)):
		e.tree_exited.connect(Callable(self, "_on_enemy_removed").bind(e))

func _on_enemy_removed(enemy: Node) -> void:
	print("enemy removed:", enemy)
	enemies.erase(enemy)
	enemies = enemies.filter(func(e): return is_instance_valid(e))

	print("Remaining enemies:", enemies.size())

	if enemies.is_empty() and not _is_active:
		print("should be unlocking")
		_unlock()

func _unlock():
	_is_active = true
	print("EnemyLock: all enemies defeated, unlocking targets")
	success_sfx.play()
	for path in targets:
		var node = get_node_or_null(path)
		if node and node is PuzzleElement:
			node.activate()

# PuzzleElement overrides
func activate():
	# Enemy locks can't be directly "pressed"
	pass

func deactivate():
	pass

func is_active() -> bool:
	return _is_active
