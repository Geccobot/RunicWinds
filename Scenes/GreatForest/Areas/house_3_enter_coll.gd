extends CollisionShape2D



func _on_house_3_enter_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().root.set_meta("facing_direction", "up")  # or "left", "right", "down"
		SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/house_3_int.tscn","up")
