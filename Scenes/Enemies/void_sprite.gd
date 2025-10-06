extends CharacterBody2D

@onready var hitbox_manager: AnimationPlayer = $Hitbox_Manager
@onready var flash: AnimationPlayer = $Flash
@onready var combat: Combat = $Combat
@onready var resources: Resources = $Resources
@onready var stats: Stats = $Resources/Stats
@onready var void_sprite: AnimatedSprite2D = $VoidSprite
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
var is_activated := false
var is_activating := false

@export var move_speed: float = 55.0
@export var attack_range: float = 64.0

var facing: String = "left" # left/right/up
var is_dying: bool = false

func _get_facing_dir(to_player: Vector2) -> String:
	if abs(to_player.x) > abs(to_player.y):
		return "right" if to_player.x > 0 else "left"
	else:
		return "up"

func _ready() -> void:
	hitbox.enable()
	enemy_health_bar.visible = false
	void_sprite.play("idle_down")
	enemy_health_bar.max_value = resources.max_health
	enemy_health_bar.value = resources.health
	if not resources.health_changed.is_connected(_on_health_changed):
		resources.health_changed.connect(_on_health_changed)
	hurtbox.hurtbox_owner = self
	if not hurtbox.hurt.is_connected(_on_hurt):
		hurtbox.hurt.connect(_on_hurt)

func _physics_process(delta: float) -> void:
	if is_dying:
		velocity = Vector2.ZERO
		move_and_slide()
		return   # stop all AI logic while dying
	
	# Knockback first
	if knockback_timer > 0.0:
		knockback_timer -= delta
		self.velocity = knockback_vector
		move_and_slide()
		return

	# No target or not activated → idle
	if target == null or not is_activated:
		self.velocity = Vector2.ZERO
		move_and_slide()
		void_sprite.play("idle_%s" % facing)
		return

	# Chase / attack
	var to_player := target.global_position - global_position
	var dist := to_player.length()

	if dist > attack_range:
		# CHASE
		var dir := to_player.normalized()
		self.velocity = dir * move_speed
		move_and_slide()
		facing = _get_facing_dir(to_player)
		void_sprite.play("move_%s" % facing) # visually same as moving
	else:
		# ATTACK
		move_and_slide()
		facing = _get_facing_dir(to_player)
		if not void_sprite.animation.begins_with("attack_"):
			void_sprite.play("attack_%s" % facing)

func _on_health_changed(new_health: int) -> void:
	enemy_health_bar.value = new_health

func _on_hurt(damage: int, from: Node) -> void:
	if from.is_in_group("Enemies"):
		return
	hit_sfx.play()
	combat.take_damage(damage, from)
	if from is Node2D:
		var dir = (global_position - (from as Node2D).global_position).normalized()
		knockback_vector = dir * knockback_strength
		knockback_timer = knockback_time

func _on_detected_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		enemy_health_bar.visible = true
		if not is_activated and not is_activating:
			is_activating = true
			is_activated = true # if you want instant activate; remove if you gate via an anim

func _on_detected_area_body_exited(body: Node2D) -> void:
	if body is Player and body == target:
		target = null

func _on_void_sprite_animation_finished() -> void:
	if void_sprite.animation.begins_with("attack_"):
		void_sprite.play("idle_%s" % facing)
		
func set_dying():
	is_dying = true
