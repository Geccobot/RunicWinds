extends Node

func _ready():
	var root = get_tree().get_current_scene()
	var player = root.get_node_or_null("World_Objects/Player")

	if not player:
		print("❌ Player not found in World_Objects!")
		return

	player.connect("player_ready", Callable(self, "_on_player_ready"))
	
func _on_player_ready():
	
	var root = get_tree().get_current_scene()
	var player = root.get_node("World_Objects/Player")
	var spawn_points = player.get_node_or_null("SpawnPoints")
	var tag = GameState.spawn_tag
	var facing = GameState.facing_direction
	print("📍 Running _on_player_ready. Tag is:", tag)
	print("Available spawn points:", spawn_points.get_children())
	if not spawn_points:
		print("❌ SpawnPoints not found under Player!")
		return
		
	if tag != "" and spawn_points.has_node(tag):
		var spawn_point = spawn_points.get_node(tag)
		player.global_position = spawn_point.global_position
		player.face_direction(facing)
		print("✅ Spawned at", tag)
	elif spawn_points.has_node("default"):
		var spawn_point = spawn_points.get_node("default")
		player.global_position = spawn_point.global_position
		player.face_direction("down")
		print("✅ Spawned at Default")
	else:
		player.global_position = Vector2.ZERO
		print("⚠️ No valid spawn point found; moved to (0,0)")
