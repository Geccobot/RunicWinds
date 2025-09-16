extends Node2D


@onready var activate_area: Area2D = $Collision/ActivateArea
@onready var collision_shape_2d: CollisionShape2D = $Collision/CollisionShape2D
@onready var detected_sfx: AudioStreamPlayer2D = $DetectedSFX
@onready var activate_sfx: AudioStreamPlayer2D = $ActivateSFX
@onready var shrine_door: AnimatedSprite2D = $Collision/ShrineDoor
@onready var area_collision_shape_2d: CollisionShape2D = $Collision/ActivateArea/CollisionShape2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $Collision/AnimationPlayer
@onready var open_sfx: AudioStreamPlayer2D = $OpenSFX


var player_in_range: Player = null
var is_activated: bool = false



func _ready() -> void:
	collision_shape_2d.disabled = false
		

func _on_activate_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = body
		player_in_range.set_interactable(self)
		if is_activated:
			pass
		else:
			detected_sfx.play()
			shrine_door.play("detected")

func _on_activate_area_body_exited(body: Node2D) -> void:
	if body is Player and body == player_in_range:
		if is_activated:
			pass
		else:
			shrine_door.play_backwards("detected")
			
		player_in_range.set_interactable(null)
		player_in_range = null
			
func interact():
	if is_activated:
		pass
	else:
		shrine_door.play("activated")
		collision_shape_2d.disabled = true
		point_light_2d.visible = true
		open_sfx.play()
		animation_player.play("lightmove")
		is_activated = true
		detected_sfx.stop()
		activate_sfx.play()
		


func _on_shrine_door_animation_finished() -> void:
	open_sfx.stop()
	point_light_2d.visible=false
