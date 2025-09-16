class_name State_mana_dash
extends State

@onready var state_machine: PlayerStateMachine = $".."
@onready var heal: State_Heal = $"../heal"

@export var dash_speed: float = 300
@export var dash_duration: float = 0.2
var dash_time: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
@onready var mana_dash_sfx: AudioStreamPlayer2D = $"../../SFX/ManaDashSFX"


@onready var idle: State_Idle = $"../idle"

func Enter() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if not player.resources.spend_stamina(20) or not player.resources.use_mana(15):
		mana_dash_sfx.stop()
		state_machine.ChangeState(idle)
		AlertManager.show_alert("Not Enough Mana or Stamina!")

	dash_dir = player.direction.normalized()

	# If there’s no input direction, cancel dash immediately
	if dash_dir == Vector2.ZERO:
		state_machine.ChangeState(idle)
		return

	dash_time = dash_duration
	player.velocity = dash_dir * dash_speed
	player.UpdateAnimation("mana_dash")
	mana_dash_sfx.pitch_scale = randf_range(0.50, 0.55)
	mana_dash_sfx.play()  # or "dash_" + facing if you want direction-based dash

func Process(delta: float) -> State:
	dash_time -= delta
	player.velocity = dash_dir * dash_speed

	if dash_time <= 0.0:
		return idle

	return null

func Exit() -> void:
	player.velocity = Vector2.ZERO
