extends Node2D
@onready var node_2d: Node2D = $"."
@onready var area_2d: Area2D = $StaticBody2D/Area2D
@onready var waypoint: AnimatedSprite2D = $StaticBody2D/waypoint
@onready var activate_sfx: AudioStreamPlayer2D = $ActivateSFX
@onready var detected_sfx: AudioStreamPlayer2D = $DetectedSFX
@onready var activated_panel: CanvasLayer = $ActivatedPanel
@onready var resonate_panel: CanvasLayer = $"Resonate Panel"
@export var waypoint_id: String 
@onready var saving_game: Label = $"Resonate Menu/Panel/saving game"
@onready var resonate_menu: CanvasLayer = $"Resonate Menu"
@onready var back_button: TextureButton = $"Resonate Menu/BackButton"
@onready var resonate_sfx: AudioStreamPlayer2D = $ResonateSFX
@onready var point_light_2d: PointLight2D = $PointLight2D

var player_in_range: Player = null
var is_activated: bool = false



func _ready():
	if Global.is_waypoint_activated(waypoint_id):
		is_activated = true
		waypoint.play("Activated")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = body
		player_in_range.set_interactable(self)

		if is_activated:
			resonate_panel.visible = true
			detected_sfx.play()
		else:
			activated_panel.visible = true
			waypoint.play("detected")
			detected_sfx.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and body == player_in_range:
		if is_activated:
			resonate_panel.visible = false
		else:
			activated_panel.visible = false
			waypoint.play_backwards("detected")
			detected_sfx.stop()

		player_in_range.set_interactable(null)
		player_in_range = null

func interact():
	if is_activated:
		resonate_menu.visible = true
		resonate_sfx.play()
		get_tree().paused=true
		Global.save_game()
		return
	else:
		is_activated = true
		Global.activate_waypoint(waypoint_id)
		point_light_2d.visible=true
		waypoint.play("activated")
		activated_panel.visible = false
		resonate_panel.visible = true
		detected_sfx.stop()
		activate_sfx.play()
		print("Waypoint activated")


func _on_back_button_pressed() -> void:
	get_tree().paused = false
	resonate_menu.visible = false
