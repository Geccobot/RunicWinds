class_name State extends Node
var player: Player

func _ready() -> void:
	
	pass 


## what happens when the player enters this State?
func Enter() -> void:
	
	pass


## what happens when a player exits this State?
func Exit() -> void:
	
	pass


## what happens during the _process update in this State?
func Process( _delta : float ) -> State:
	
	return null


## what happens during the _physics_process update in this State?
func Physics( _delta : float ) -> State:
	
	return null


## what happens during input in this state?
func HandleInput (event: InputEvent ) -> State:
	
	return null
