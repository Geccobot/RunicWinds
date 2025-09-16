class_name State_Attack
extends State

var can_chain: bool = false
var attack_queued: bool = false
var in_attack_end: bool = false
var just_switched_to_attack_end: bool = false

@onready var sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var idle: State_Idle = $"../idle"
@onready var slash_sfx: AudioStreamPlayer2D = $"../../SFX/SlashSFX"
@onready var footstep_sfx: AudioStreamPlayer2D = $"../../SFX/FootstepSFX"
@onready var hitbox_helper: AnimationPlayer = $"../../HitboxHelper"


const ATTACK_STAMINA_COST := 10

func Setup(p: Player) -> void:
	player = p
	sprite = player.sprite
	idle = player.state_machine.get_node("idle")  # Adjust path if needed


func Enter() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Try to pay stamina first
	if not player.resources.spend_stamina(ATTACK_STAMINA_COST):
		# Not enough stamina: bail out gracefully to idle
		attack_queued = false
		in_attack_end = true
		just_switched_to_attack_end = true
		AlertManager.show_alert("Not Enough Stamina!")
		return

	can_chain = false
	attack_queued = false
	in_attack_end = false
	just_switched_to_attack_end = false
	player.velocity = Vector2.ZERO
	player.SetDirection()
	player.UpdateAnimation("attack")
	player.UpdateHitBox()
	player.sprite.frame = 0
	player.sprite.play()

	slash_sfx.pitch_scale = randf_range(0.9, 1.1)
	slash_sfx.play()
	
func Exit() -> void:
	# Reset everything when exiting
	can_chain = false
	attack_queued = false
	in_attack_end = false
	just_switched_to_attack_end = false

func HandleInput(event: InputEvent) -> State:
	# Handle attack chaining (when we're not in the "end" state)
	if !in_attack_end and can_chain and event.is_action_pressed("attack"):
		attack_queued = true
	return null

func Process(_delta: float) -> State:
	
	var current_frame = sprite.frame
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)

	# Check if we’re within the chaining window
	can_chain = !in_attack_end and current_frame >= 3 and current_frame <= 6

	# Handle end of attack animation
	if !in_attack_end and current_frame >= total_frames - 1:
		if attack_queued:
			hitbox_helper.stop()
			Enter()  # Re-trigger this state
			return self
		else:
			in_attack_end = true
			just_switched_to_attack_end = true

	# Handle attack_end animation
	elif in_attack_end:
		if just_switched_to_attack_end:
			player.UpdateAnimation("attack_end")
			sprite.frame = 0
			sprite.play()
			just_switched_to_attack_end = false
		elif sprite.frame == sprite.sprite_frames.get_frame_count(sprite.animation) - 1:
			return idle

	return null
