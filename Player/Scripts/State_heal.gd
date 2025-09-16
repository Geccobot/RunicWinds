class_name State_Heal extends State
@onready var heal: AnimatedSprite2D = $"../../Heal"
@onready var resources: Resources = $"../../Resources"
@onready var idle: State_Idle = $"../idle"
@onready var heal_sfx: AudioStreamPlayer2D = $"../../SFX/HealSFX"


var heal_end = false
var is_lit = false
func _ready() -> void:
	
	pass 


## what happens when the player enters this State?
func Enter() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	heal_sfx.play()
	heal.play("heal")
	resources.heal(20)
	pass


## what happens when a player exits this State?
func Exit() -> void:

	pass


## what happens during the _process update in this State?
func Process( _delta : float ) -> State:
	
	return null


## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	if heal_end == true:
		
		return idle
	return null


## what happens during input in this state?
func HandleInput (event: InputEvent ) -> State:
	
	return null


func _on_heal_animation_finished() -> void:
	heal_end = true
