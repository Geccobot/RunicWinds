# Combat.gd
extends Node
class_name Combat

@onready var resources: Resources = $"../Resources"
@export_node_path("AnimatedSprite2D") var sprite_path: NodePath
@export_node_path("AudioStreamPlayer2D") var death_sound: NodePath

var sprite: AnimatedSprite2D
var death_sfx: AudioStreamPlayer2D
var is_dying: bool = false

func _ready() -> void:
	# Setup sprite
	if sprite_path != NodePath():
		sprite = get_node(sprite_path) as AnimatedSprite2D
	else:
		sprite = _find_first_sprite(owner)

	# Setup audio
	if death_sound != NodePath():
		death_sfx = get_node(death_sound) as AudioStreamPlayer2D

	# Auto-connect Hurtbox if present
	var hurtbox := owner.get_node_or_null("Hurtbox")
	if hurtbox and not hurtbox.is_connected("hurt", Callable(self, "take_damage")):
		hurtbox.connect("hurt", Callable(self, "take_damage"))

func _find_first_sprite(n: Node) -> AnimatedSprite2D:
	for c in n.get_children():
		if c is AnimatedSprite2D:
			return c
		var deep := _find_first_sprite(c)
		if deep:
			return deep
	return null

func take_damage(amount: int, from: Node) -> void:
	if is_dying:
		return
	resources.take_damage(amount, from)
	if resources.health <= 0:
		await _play_death_then_free()

func _play_death_then_free() -> void:
	if is_dying:
		return
	is_dying = true
	
	if owner.has_method("set_dying"): # optional helper
		owner.set_dying()

	var hb := owner.get_node_or_null("Hurtbox")
	if hb:
		hb.set_deferred("monitoring", false)
		hb.set_deferred("monitorable", false)
	var hit := owner.get_node_or_null("Hitbox")
	if hit:
		hit.set_deferred("monitoring", false)
	if death_sfx:
		death_sfx.play()
	
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation("death"):
		sprite.play("death")
	if not sprite.is_connected("animation_finished", Callable(self, "_on_death_animation_finished")):
		sprite.connect("animation_finished", Callable(self, "_on_death_animation_finished"))
	else:
		_on_death_animation_finished()


func _on_death_animation_finished() -> void:
	if not is_instance_valid(owner):
		return
	var dropper := owner.get_node_or_null("ItemDrop")
	if dropper:
		dropper.spawn_drop()
	owner.queue_free()
