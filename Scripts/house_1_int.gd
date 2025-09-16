extends Node2D
@onready var player: Player = $World_Objects/Player


func _ready() -> void:
	SceneTransition.animate_entrance()
