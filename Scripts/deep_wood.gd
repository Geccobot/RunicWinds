extends Node2D
@onready var player: Player = $World_Objects/Player
@onready var name_panel: CanvasLayer = $NamePanel
@onready var timer: Timer = $Timer
@onready var dark_shadow: DirectionalLight2D = $Dark_Shadow
@onready var darken_area: Area2D = $"Darken Area"


var is_dark: bool = false

func _ready():
	SceneTransition.animate_entrance()
	AlertManager.show_name_alert("DeepWood")
	dark_shadow.energy = 0.0   # start off (fully bright)
	is_dark = false

func _on_darken_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_dark = not is_dark
		var tween := get_tree().create_tween()
		if is_dark:
			tween.tween_property(dark_shadow, "energy", 1.0, 1.5)
		else:
			tween.tween_property(dark_shadow, "energy", 0.0, 1.5)
