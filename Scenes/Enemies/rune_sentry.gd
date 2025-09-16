extends CharacterBody2D

@onready var rune_sentry: AnimatedSprite2D = $Rune_Sentry
@onready var resources: Resources = $Resources
@onready var stats: Stats = $Resources/Stats
@onready var combat: Combat = $Combat
@onready var enemy_health_bar: HealthBar = $"Enemy_Health Bar"
@onready var hitbox_manager: AnimationPlayer = $Hitbox_Manager
@onready var flash: AnimationPlayer = $Flash
@onready var hit_sfx: AudioStreamPlayer2D = $SFX/HitSFX
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var detected_area: Area2D = $DetectedArea
@onready var attack_timer: Timer = $AttackTimer
var knockback_vector: Vector2 = Vector2.ZERO
@export var knockback_strength: float = 120.0
@export var knockback_time: float = 0.2
var knockback_timer: float = 0.0


var is_activated = false
var is_activating: bool = false
var target: Player
var is_attacking: bool = false
var can_attack: bool = true
var facing: String = "down"   # up, down, left, right

@export var move_speed: float = 55.0
@export var attack_range: float = 64.0  

func _ready() -> void:
	enemy_health_bar.visible = false
	rune_sentry.play("unactivated_down")
	enemy_health_bar.max_value = resources.max_health
	enemy_health_bar.value = resources.health
	if not resources.health_changed.is_connected(_on_health_changed):
		resources.health_changed.connect(_on_health_changed)

	hurtbox.hurtbox_owner = self
	if not hurtbox.hurt.is_connected(_on_hurt):
		hurtbox.hurt.connect(_on_hurt)

# --- Update facing direction ---
func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			# Moving right → flip the art, since default is left
			facing = "right"
			rune_sentry.flip_h = true
		else:
			# Moving left → use default orientation (no flip)
			facing = "left"
			rune_sentry.flip_h = false
	else:
		facing = "down" if dir.y > 0 else "up"


func _physics_process(delta: float) -> void:
		# Handle knockback first
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_vector
		move_and_slide()
		return
	
	# If we don't have a target yet, idle and bail early
	if target == null or not is_activated:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# We have a target: chase/attack logic
	var to_player := target.global_position - global_position
	var dist := to_player.length() + 4

	if dist > attack_range:
		# CHASE
		var dir := to_player.normalized()
		velocity = dir * move_speed
		move_and_slide()

		_update_facing(dir)

		var anim = "walk_side" if facing in ["left", "right"] else "walk_" + facing
		if rune_sentry.animation != anim and not is_attacking:
			rune_sentry.play(anim)

	else:
		# IN RANGE
		velocity = Vector2.ZERO
		move_and_slide()

		if is_attacking:
			pass # don’t interrupt active attack
		elif not can_attack:
			var idle_anim = "idle_side" if facing in ["left", "right"] else "idle_" + facing
			if rune_sentry.animation != idle_anim:
				rune_sentry.play(idle_anim)
		else:
			_start_attack()

# --- Damage reception ---
func _on_hurt(damage: int, from: Node) -> void:
	# Ignore if the attacker is in the "Enemies" group
	if from.is_in_group("Enemies"):
		return

	# Otherwise, take damage
	hit_sfx.play()
	combat.take_damage(damage, from)
	
		# Knockback
	if from and from is Node2D:
		var dir = (global_position - from.global_position).normalized()
		knockback_vector = dir * knockback_strength
		knockback_timer = knockback_time

func _on_health_changed(new_health: int) -> void:
	enemy_health_bar.value = new_health

# --- Detection ---
func _on_detected_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		enemy_health_bar.visible = true
		hitbox_manager.play("ShowHealth")

		if not is_activated and not is_activating:
			is_activating = true
			rune_sentry.play("activate_down")

# --- Attack ---
func _start_attack() -> void:
	if is_activated:
		is_attacking = true
		can_attack = false
		hitbox.Boxowner = self

		var attack_anim = "attack_side" if facing in ["left", "right"] else "attack_" + facing
		rune_sentry.play(attack_anim)

		var hitbox_anim = "Hitbox_" + facing
		hitbox_manager.play(hitbox_anim)

func _on_rune_sentry_animation_finished() -> void:
	if rune_sentry.animation.begins_with("attack_"):
		is_attacking = false
		hitbox_manager.stop()
		attack_timer.start()

		var idle_anim = "idle_side" if facing in ["left", "right"] else "idle_" + facing
		rune_sentry.play(idle_anim)

	elif rune_sentry.animation == "activate_down":
		is_activated = true
		is_activating = false
		rune_sentry.play("idle_down")

# --- Lost player ---
func _on_detected_area_body_exited(body: Node2D) -> void:
	if body is Player and body == target:
		target = null
		hitbox_manager.play_backwards("ShowHealth")
		rune_sentry.play("idle_down")

func _on_attack_timer_timeout() -> void:
	can_attack = true
