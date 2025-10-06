extends CharacterBody2D 

@export var timeline_name: String = "Duke"

@onready var dialog_area: Area2D = $DialogArea
@onready var dialog_area_coll: CollisionShape2D = $DialogArea/DialogAreaColl

var player_in_range: Player = null
var is_talking: bool = false

func _on_dialog_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = body
		player_in_range.set_interactable(self)

func _on_dialog_area_body_exited(body: Node2D) -> void:
	if body is Player and player_in_range == body:
		player_in_range.set_interactable(null)
		player_in_range = null

func interact() -> void:
	if player_in_range == null:
		return
	
	# Assign the timeline name to the player
	player_in_range.dialogue_timeline = timeline_name
	
	# Switch the player into Dialogue state
	player_in_range.state_machine.ChangeState(player_in_range.dialogue)
	is_talking = true

func _on_dialogue_finished(_timeline: String) -> void:
	is_talking = false
