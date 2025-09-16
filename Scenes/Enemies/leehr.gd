extends CharacterBody2D

@onready var hitbox_manager: AnimationPlayer = $Hitbox_Manager
@onready var flash: AnimationPlayer = $Flash
@onready var combat: Combat = $Combat
@onready var resources: Resources = $Resources
@onready var stats: Stats = $Resources/Stats
@onready var leehr: AnimatedSprite2D = $Leehr
@onready var hit_sfx: AudioStreamPlayer2D = $SFX/HitSFX
@onready var enemy_health_bar: HealthBar = $"Enemy_Health Bar"
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var detected_area: Area2D = $DetectedArea
@onready var death_timer: Timer = $DeathTimer
var knockback_vector: Vector2 = Vector2.ZERO
@export var knockback_strength: float = 120.0
@export var knockback_time: float = 0.2
var knockback_timer: float = 0.0

var target: Player
var is_activated = false
var is_activating = false

@export var move_speed: float = 55.0
@export var attack_range: float = 64.0 


func _ready() -> void:
	leehr.z_index=1
	hitbox.enable()
	enemy_health_bar.visible = false
	leehr.play("unactivated_down")
	enemy_health_bar.max_value = resources.max_health
	enemy_health_bar.value = resources.health
	if not resources.health_changed.is_connected(_on_health_changed):
		resources.health_changed.connect(_on_health_changed)

	hurtbox.hurtbox_owner = self
	if not hurtbox.hurt.is_connected(_on_hurt):
		hurtbox.hurt.connect(_on_hurt)
		
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

	# Chase/attack logic
	var to_player := target.global_position - global_position
	var dist := to_player.length()   # removed +4

	if dist > attack_range:
		# CHASE
		leehr.z_index=1
		var dir := to_player.normalized()
		velocity = dir * move_speed
		move_and_slide()
		if leehr.animation != "fly":
			leehr.play("fly")
	else:
		# IN RANGE (no attack yet → just idle in place)
		leehr.z_index=0
		velocity = Vector2.ZERO
		move_and_slide()
		if leehr.animation != "fly":
			leehr.play("fly")

		
func _on_health_changed(new_health: int) -> void:
	enemy_health_bar.value = new_health
	

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
		
func _on_detected_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		enemy_health_bar.visible = true
		if not is_activated and not is_activating:
			is_activating = true
			leehr.play("activate_down")

			
func _on_detected_area_body_exited(body: Node2D) -> void:
	if body is Player and body == target:
		target = null
		



func _on_leehr_animation_finished() -> void:
	if leehr.animation == "activate_down":
		is_activated = true
		is_activating = false
		leehr.play("fly")
