class_name Player
extends CharacterBody2D
var tween: Tween
var cardinal_direction = Vector2.UP
static var direction : Vector2 = Vector2.ZERO
var interactable: Node = null
var dialogue_timeline: String = ""

@onready var hitbox_helper: AnimationPlayer = $HitboxHelper
@onready var flash: AnimationPlayer = $Flash
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = $StateMachine
@onready var slash_sfx: AudioStreamPlayer2D = $SFX/SlashSFX
@onready var footstep_sfx: AudioStreamPlayer2D = $SFX/FootstepSFX
@onready var fireball_sfx: AudioStreamPlayer2D = $SFX/FireballSFX
@onready var flarel_sfx: AudioStreamPlayer2D = $SFX/FlarelSFX
@onready var gust_sfx: AudioStreamPlayer2D = $SFX/GustSFX
@onready var aero_slash_sfx_2: AudioStreamPlayer2D = $SFX/AeroSlashSFX2
@onready var damage_sfx: AudioStreamPlayer2D = $SFX/DamageSFX
@onready var lantern: PointLight2D = $lantern
@onready var resources: Resources = $Resources
@onready var combat: Combat = $Combat
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var pause_sfx: AudioStreamPlayer2D = $SFX/PauseSFX
@onready var unpause_sfx: AudioStreamPlayer2D = $SFX/UnpauseSFX
@onready var heal_light: PointLight2D = $StateMachine/heal/Heal_Light
@onready var dialogue: State_Dialogue = $StateMachine/dialogue
@onready var idle: State_Idle = $StateMachine/idle



signal player_ready

func _ready():
	collision_shape_2d.disabled=true
	tween = create_tween()
	hitbox.Boxowner = self
	hitbox.disable()                 # make sure it starts off
	hurtbox.hurtbox_owner = self
	hurtbox.connect("hurt", Callable(self, "_on_player_hurt"))


	var root = get_tree().get_current_scene()

	# First calculate stats-based max values
	resources.calculate_resources()

	# Grab HUD bars
	@warning_ignore("unused_variable")
	var hud = get_tree().get_current_scene().get_node("HUD/HUD_panel")
	var health_bar: HealthBar = root.get_node("HUD/HUD_panel/HealthBar")
	@warning_ignore("shadowed_variable")
	var stamina_bar: StaminaBar = root.get_node("HUD/HUD_panel/StaminaBar")
	var mana_bar: ManaBar = root.get_node("HUD/HUD_panel/ManaBar")

	# Hook resources to bars
	resources.connect("health_changed", Callable(health_bar, "_set_health"))
	resources.connect("stamina_changed", Callable(stamina_bar, "_set_stamina"))
	resources.connect("mana_changed", Callable(mana_bar, "_set_mana"))

	# Initialize bars to max values
	health_bar.init_health(resources.max_health)
	stamina_bar.init_stamina(resources.max_stamina)
	mana_bar.init_mana(resources.max_mana)

	# State machine + signals
	state_machine.Initialize(self)
	$Hurtbox.connect("hurt", Callable(self, "_on_player_hurt"))
	sprite.connect("frame_changed", Callable(self, "_on_frame_changed"))

	GestureManager.connect("gesture_performed", Callable(self, "_on_gesture_performed"))

	emit_signal("player_ready")
	

@warning_ignore("unused_parameter")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		# For now: attack whatever you’re facing (could be expanded later)
		var target = get_attack_target()
		if target:
			combat.perform_attack(target)
	
	if Input.is_action_just_pressed("Lantern") and GlobalKeys.has_lantern:
		GlobalKeys.lantern_lit = not GlobalKeys.lantern_lit
		lantern.toggle()
			
	if Input.is_action_just_pressed("Pause"):
		PauseMenu.pause_game()
	
	if Input.is_action_just_pressed("Input"):
		PauseMenu.open_inventory()
		
func center_mouse_on_player() -> void:
	var viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x / 2
	var center_y = viewport_size.y / 2
	Input.warp_mouse(Vector2(center_x+350, center_y+20))

func _physics_process(_delta: float) -> void:
	direction.x = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
	direction.y = Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp")
	move_and_slide()

	if Input.is_action_just_pressed("Interact"):
		if interactable and interactable.has_method("interact"):
			interactable.interact()

# Inside your Player script, in _physics_process or HandleInput
	if Input.is_action_just_pressed("Interact") and interactable and interactable is PushableBlock:
		var dir = direction.normalized().round()
		print("player pressed interact on the block")
		(interactable as PushableBlock).try_push(dir)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				GestureManager.start_gesture()
			else:
				GestureManager.end_gesture()
	elif event is InputEventMouseMotion:
		GestureManager.update_gesture()

func _on_player_hurt(damage: int, from: Node) -> void:
	combat.take_damage(damage, from)
	flash.play("FlashRed")
	
	damage_sfx.play()
	
func get_attack_target() -> Node:
	return hitbox.current_target

func _attack_window_open() -> void:
	hitbox.enable()
	
func _attack_window_close() -> void:
	hitbox.disable()
	
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.RIGHT else 1
	return true

func UpdateAnimation(state: String) -> void:

	if not sprite:
		return
	var anim_dir = AnimDirection()
	var anim_name = state + "_" + anim_dir
	sprite.play(anim_name)
	
	
func UpdateHitBox():
	print("Hitbox updated")
	if cardinal_direction== Vector2.DOWN:
		ray_cast_2d.target_position.x = 0 
		ray_cast_2d.target_position.y = 22
		hitbox_helper.play("hitbox_down")
	elif cardinal_direction== Vector2.UP:
		ray_cast_2d.target_position.x = 0 
		ray_cast_2d.target_position.y = -22
		hitbox_helper.play("hitbox_up")
	elif cardinal_direction == Vector2.LEFT:
		ray_cast_2d.target_position.x = -22 
		ray_cast_2d.target_position.y = 0
		hitbox_helper.play("hitbox_left")
	else:
		ray_cast_2d.target_position.x = 22 
		ray_cast_2d.target_position.y = 0
		hitbox_helper.play("hitbox_right")
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func face_direction(dir: String) -> void:
	match dir:
		"up":
			cardinal_direction = Vector2.UP
		"down":
			cardinal_direction = Vector2.DOWN
		"left":
			cardinal_direction = Vector2.LEFT
		"right":
			cardinal_direction = Vector2.RIGHT

	if sprite:
		sprite.scale.x = -1 if cardinal_direction == Vector2.RIGHT else 1
		UpdateAnimation("idle")

func _on_frame_changed():
	if sprite.animation.begins_with("run"):
		if sprite.frame == 0 or sprite.frame == 3:
			footstep_sfx.pitch_scale = randf_range(0.95, 1.05)
			footstep_sfx.play()

func _on_gesture_performed(pattern: Array) -> void:
	var spell_name = ""
	var mana_cost := 0

	match pattern:
		["right"]:
			spell_name = "fireball"
			mana_cost = 7
		["right", "left"]:
			spell_name = "flarel"
			mana_cost = 15
		["up"]:
			spell_name = "gust"
			mana_cost = 8
		["up", "down"]:
			spell_name = "aero_slash"
			mana_cost = 12
		_:
			print("Unknown gesture pattern:", pattern)

	if spell_name == "":
		return

	# Pay mana first; HUD updates via signal
	if not resources.use_mana(mana_cost):
		AlertManager.show_alert("Not Enough Mana!")
		return

	# Succeed → cast spell
	SpellManager.cast_spell(spell_name, global_position, cardinal_direction, self)

func set_interactable(obj: Node):
	interactable = obj

func ChangeState(new_state: State) -> void:
	state_machine.ChangeState(new_state)
