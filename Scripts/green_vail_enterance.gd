extends CollisionShape2D

func _on_green_veil_enter_deep_wood_body_entered(body: Node2D) -> void:
	if body is Player:
		GameState.spawn_tag = "from_DeepWood"  # This must match a node in Player/SpawnPoints
		GameState.facing_direction = "down"
		print("GameState.spawn_tag=") 
		print(GameState.spawn_tag)
		SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/GreenVeil.tscn", "down")


func _on_green_veil_enter_great_forest_body_entered(body: Node2D) -> void:
	if body is Player:
		GameState.spawn_tag = "from_GreatForest"  # This must match a node in Player/SpawnPoints
		GameState.facing_direction = "left"
		print("GameState.spawn_tag=") 
		print(GameState.spawn_tag)
		SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/GreenVeil.tscn", "left")
