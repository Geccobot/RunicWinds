extends Node
class_name ItemDrop

@export_range(0.0, 1.0) var gold_drop_chance: float = 0.5
@export var gold_amount: int = 5

@export_range(0.0, 1.0) var item_drop_chance: float = 0.3
@export var possible_items: Array[ItemData] = []  # drag in items via inspector

@export var gold_pickup_scene: PackedScene
@export var item_pickup_scene: PackedScene

func spawn_drop():
	var roll = randf()
	if roll < gold_drop_chance:
		_spawn_gold()
	elif roll < gold_drop_chance + item_drop_chance and possible_items.size() > 0:
		_spawn_item()
	# else → no drop

func _spawn_gold():
	if not gold_pickup_scene: return
	var gold := gold_pickup_scene.instantiate()
	_spawn_drop_to_layer(gold)

func _spawn_item():
	if not item_pickup_scene: return
	var p := item_pickup_scene.instantiate()
	p.item = possible_items.pick_random()
	p.amount = 1
	_spawn_drop_to_layer(p)
	
func _spawn_drop_to_layer(node: Node2D):
	var layer := get_tree().current_scene.get_node_or_null("World_Objects/PU's")
	print(layer)
	if layer == null:
		# fallback: root
		layer = get_tree().current_scene
	layer.add_child(node)
	node.global_position = owner.global_position
