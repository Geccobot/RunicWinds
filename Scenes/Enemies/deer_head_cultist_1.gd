extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Hitbox
@onready var resources: Resources = $Resources
@onready var combat: Combat = $Combat
@onready var enemy_health_bar: HealthBar = $"Enemy_Health Bar"  # keep your path/name
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sfx: AudioStreamPlayer2D = $SFX/HitSFX
@onready var hb_anim: AnimationPlayer = $Hitbox/AnimationPlayer


# --- Tuning ---
@export var move_speed: float = 55.0
@export var attack_range: float = 64.0        # was ~26; increase reach
@export var attack_cooldown: float = 2.0      # seconds between full attacks
@export var attack_windup: float = 0.25       # pre-swing tell
@export var attack_active: float = 0.18       # hitbox “on” window


# --- Runtime ---
var target: Player = null
var armed: bool = false           # becomes true after Ready_down plays
var is_attacking: bool = false
var can_attack: bool = true

# Keep your existing “detected” flags
var waiting_for_ready_down: bool = false
var player_inside: bool = false
var reversing_set_down: bool = false

func _ready() -> void:
	# Init bar
	enemy_health_bar.max_value = resources.max_health
	enemy_health_bar.value = resources.health
	if not resources.health_changed.is_connected(_on_health_changed):
		resources.health_changed.connect(_on_health_changed)

	# Hook hurtbox
	hurtbox.hurtbox_owner = self
	if not hurtbox.hurt.is_connected(_on_hurt):
		hurtbox.hurt.connect(_on_hurt)

	# Hitbox OFF by default; enable only during attack swing
	_hitbox_disable()

	# Connect anim finished
	if not animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		animated_sprite_2d.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if not armed or is_attacking or target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player := target.global_position - global_position
	var dist := to_player.length()

	if dist > attack_range:
		# CHASE
		var dir := to_player.normalized()
		velocity = dir * move_speed
		move_and_slide()
		if animated_sprite_2d.animation != "walk_down":
			animated_sprite_2d.play("walk_down")
	else:
		# IN RANGE
		velocity = Vector2.ZERO
		move_and_slide()
		if can_attack and not is_attacking:
			_start_attack()

# -----------------------
# Detection → “set” flow
# -----------------------
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not player_inside:
		player_inside = true
		waiting_for_ready_down = true
		reversing_set_down = false
		target = body
		animated_sprite_2d.play("set_down")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player and player_inside:
		player_inside = false
		waiting_for_ready_down = false
		reversing_set_down = true
		target = null
		animated_sprite_2d.play_backwards("set_down")

func _on_animation_finished() -> void:
	if waiting_for_ready_down and animated_sprite_2d.animation == "set_down":
		animated_sprite_2d.play("Ready_down")
		waiting_for_ready_down = false
		armed = true                       # ✅ now we can chase/attack
	elif reversing_set_down:
		animated_sprite_2d.play("idle_down")
		reversing_set_down = false

# -----------------------
# Attack sequence
# -----------------------
func _start_attack() -> void:
	is_attacking = true
	can_attack = false
	if armed == true:
	# Main swing
		animated_sprite_2d.play("attack_down")

	# Restart the hitbox animation deterministically
		if hb_anim:
		
			hb_anim.play("Hitbox_down")
		
	
	is_attacking = false

	# Hard cooldown so we don't spam
	can_attack = true
	



# -----------------------
# Damage & bar updates
# -----------------------
func _on_hurt(damage: int, from: Node) -> void:
	animation_player.play("FlashRed")
	hit_sfx.play()
	combat.take_damage(damage, from)  # routes to Resources; bar updates via signal

func _on_health_changed(new_health: int) -> void:
	enemy_health_bar.value = new_health

# -----------------------
# Hitbox helpers
# -----------------------
func _hitbox_enable() -> void:
	if hitbox:
		hitbox.monitoring = true
		var shape := hitbox.get_node_or_null("CollisionShape2D")
		if shape: shape.disabled = false
		# If your hitbox wants to know its owner:
		hitbox.Boxowner = self

func _hitbox_disable() -> void:
	if hitbox:
		hitbox.monitoring = false
		var shape := hitbox.get_node_or_null("CollisionShape2D")
		
