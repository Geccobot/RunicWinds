extends CollisionShape2D


func _on_great_forest_enter_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().root.set_meta("facing_direction", "left")  # or "left", "right", "down"
		SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/great_forest.tscn", "left")
