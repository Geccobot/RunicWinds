extends CollisionShape2D





func _on_green_veil_enter_body_entered(body: Node2D) -> void:
	if body is Player:
		GameState.spawn_tag = "from_House1"  # This must match a node in Player/SpawnPoints
		GameState.facing_direction = "down"
		SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/GreenVeil.tscn","down")
