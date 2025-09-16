class_name State_Run_Spell extends State

@onready var idle_spell: State_Idle_Spell = $"../idle_spell"
@onready var run: State_Run = $"../run"
@onready var idle: State_Idle = $"../idle"
@export var speed : float = 100
@onready var mana_dash: State_mana_dash = $"../mana_dash"
@onready var heal: State_Heal = $"../heal"


func Enter() -> void:
	# First, center the mouse on the player
	player.center_mouse_on_player()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Then move the particles to match the *new* mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	MouseParticles.global_position = mouse_pos

	# Now restart/emit
	MouseParticles.restart()
	MouseParticles.emitting = true
	MouseParticles.show()

	player.UpdateAnimation("spell") 
	GestureManager.start_gesture()
func Exit() -> void:
	MouseParticles.restart()
	MouseParticles.emitting = false
	MouseParticles.hide()
	GestureManager.end_gesture()

func Process(_delta: float) -> State:
	GestureManager.update_gesture()
	player.velocity = player.direction * speed

	# Transition if released
	if not Input.is_action_pressed("spell"):
		return run

	# Transition to idle_spell if you stop moving
	if player.direction == Vector2.ZERO:
		return idle_spell

	player.SetDirection()
	player.UpdateAnimation("run_spell")

	return null



func HandleInput(event: InputEvent) -> State:
	if event.is_action_pressed("heal"):
		return heal
	if event.is_action_pressed("Dash"):
		return mana_dash
	if event.is_action_released("spell"):
		return run
	return null
