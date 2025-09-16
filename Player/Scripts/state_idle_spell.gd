class_name State_Idle_Spell extends State
@onready var idle: State_Idle = $"../idle"
@onready var run: State_Run = $"../run"
@onready var run_spell: State_Run_Spell = $"../run_spell"
func _ready() -> void:
	pass


## what happens when the player enters this State?
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


## what happens when a player exits this State?
func Exit() -> void:
	MouseParticles.restart()
	MouseParticles.emitting = false
	MouseParticles.hide()
	GestureManager.end_gesture()


## what happens during the _process update in this State?
func Process(_delta: float) -> State:
	GestureManager.update_gesture()
	# If released, go back to idle
	if not Input.is_action_pressed("spell"):
		return idle

	# If started moving while still holding, switch to run_spell
	if player.direction != Vector2.ZERO:
		return run_spell

	return null


## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	
	return null


## what happens during input in this state?
func HandleInput (event: InputEvent ) -> State:
	return null
