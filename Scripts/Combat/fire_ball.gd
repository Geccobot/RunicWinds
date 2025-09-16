extends Area2D

@export var speed: float = 300
@export var damage: int = 20
@export var direction: Vector2 = Vector2.RIGHT
@export var lifetime: float = 1.5
@export var Boxowner: Node = null
@export var caster: Node = null

@onready var hit_box: Hitbox = $HitBox
@onready var despawn_timer: Timer = $DespawnTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cast_sfx: AudioStreamPlayer2D = $cast_SFX
@onready var hit_sfx: AudioStreamPlayer2D = $hit_SFX

var has_collided: bool = false

func update_animation_direction():
	var anim = ""
	var hit_anim = ""

	if abs(direction.x) > abs(direction.y):
		# Moving horizontally
		anim = "cast_side"
		hit_anim = "hit_side"
		animated_sprite_2d.flip_h = direction.x < 0
	else:
		animated_sprite_2d.flip_h = false
		if direction.y > 0:
			anim = "cast_down"
			hit_anim = "hit_down"
		else:
			anim = "cast_up"
			hit_anim = "hit_up"

	# Store which hit animation to use
	animated_sprite_2d.animation = anim
	animated_sprite_2d.set_meta("hit_anim", hit_anim)

func _ready():
	update_animation_direction()
	animated_sprite_2d.play()
	hit_box.damage = damage
	hit_box.Boxowner = Boxowner
	despawn_timer.start(lifetime)
	cast_sfx.play()
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	if not has_collided:
		position += direction.normalized() * speed * delta

func _on_body_entered(body):
	if has_collided:
		return

	if body == caster or body.is_in_group("player"):
		return

	has_collided = true
	hit_sfx.play()
	var hit_anim = animated_sprite_2d.get_meta("hit_anim")
	animated_sprite_2d.play(hit_anim)

func _on_area_entered(area: Area2D) -> void:
	if has_collided:
		return

	if area == caster or area.get_parent() == caster or area.is_in_group("player"):
		return

	if area.is_in_group("hurtbox"):
		area.emit_signal("hurt", damage, caster)
		has_collided = true
		hit_sfx.play()
		var hit_anim = animated_sprite_2d.get_meta("hit_anim")
		animated_sprite_2d.play(hit_anim)

func _on_animation_finished():
	if animated_sprite_2d.animation.begins_with("hit"):
		queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
