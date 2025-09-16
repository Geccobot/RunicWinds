class_name State_Run extends State

@onready var attack: State = $"../attack"
@onready var idle: State_Idle = $"../idle"
@onready var run_spell: State_Run_Spell = $"../run_spell"
@export var speed: float = 100
@onready var dash: Node = $"../dash"
@onready var heal: State_Heal = $"../heal"

func Enter() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player.UpdateAnimation("run")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	player.velocity = player.direction * speed

	if Input.is_action_pressed("spell"):
		return run_spell

	if player.direction == Vector2.ZERO:
		return idle

	if player.SetDirection():
		player.UpdateAnimation("run")

	return null

func HandleInput(event: InputEvent) -> State:
	if event.is_action_pressed("heal"):
		return heal
	if event.is_action_pressed("Dash"):
		return dash   # assuming you `@onready var dash: State_Dash = $"../dash"`
	if event.is_action_pressed("attack"):
		return attack
	return null
