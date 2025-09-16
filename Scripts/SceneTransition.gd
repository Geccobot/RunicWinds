extends CanvasLayer

@onready var fade_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target_scene: String = ""
var facing_direction: String = "down"

signal scene_transitioned

func animate_exit(scene_path: String, direction: String) -> void:
	target_scene = scene_path
	facing_direction = direction

	GameState.facing_direction = direction

	fade_rect.visible = true
	animation_player.play("fade_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		get_tree().change_scene_to_file(target_scene)
	elif anim_name == "fade_out":
		fade_rect.visible = false
		emit_signal("scene_transitioned")

func animate_entrance():
	fade_rect.visible = true
	animation_player.play("fade_out")

func _ready():
	if GameState.spawn_tag != "":
		animate_entrance()
