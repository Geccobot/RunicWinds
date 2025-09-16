extends Node2D
@onready var player: Player = $Player

func _ready() -> void:
	
	SceneTransition.animate_entrance()
	AlertManager.show_name_alert("The Great Forest")
	var facing_dir = get_tree().root.get_meta("facing_direction", null)
	if facing_dir != null and player and player.has_method("face_direction"):
		player.face_direction(facing_dir)
	get_tree().root.set_meta("facing_direction", null)  # Clear meta


func _process(delta: float) -> void:
	pass
