class_name State_Idle extends State

@onready var attack: State = $"../attack"
@onready var idle_spell: State_Idle_Spell = $"../idle_spell"
@onready var run: State_Run = $"../run"
@onready var dash: Node = $"../dash"
@onready var heal: State_Heal = $"../heal"
@onready var dialogue: State_Dialogue = $"../dialogue"

var magic_cursor = load("res://Assets/Sprites/GamePlay/Cursor.png")

func Enter() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_custom_mouse_cursor(magic_cursor, 0 , Vector2(0,0))
	player.velocity = Vector2.ZERO
	player.UpdateAnimation("idle")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if Input.is_action_pressed("spell"):
		return idle_spell

	if player.direction != Vector2.ZERO:
		return run

	player.velocity = Vector2.ZERO
	return null

func HandleInput(event: InputEvent) -> State:
	if event.is_action_pressed("heal"):
		return heal
	if event.is_action_pressed("attack"):
		print("Attack Entered")
		return attack
	if event.is_action_pressed("Dash"):
		return dash   # assuming you `@onready var dash: State_Dash = $"../dash"`
	if event.is_action_pressed("Interact") and player.interactable and player.interactable.is_in_group("NPC"):
		player.interactable.interact()
		return dialogue
	return null
