extends Node2D

@onready var small_chest: AnimatedSprite2D = $StaticBody2D/SmallChest
@onready var open_sfx: AudioStreamPlayer2D = $OpenSFX

@export var item: ItemData
@export var amount: int = 1


var is_opened: bool = false
var player_in_range: Player = null

func _ready() -> void:
	is_opened = false
	small_chest.stop()
	small_chest.play("closed")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = body
		player_in_range.set_interactable(self)
		if is_opened:
			pass
		

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range.set_interactable(null)
		player_in_range = null

func interact() -> void:
	if is_opened:
		pass
	else:
		Inventory.add_item(item, amount)
		AlertManager.show_alert("Picked up %d x %s" % [amount, item.display_name])
		open_sfx.play()
		small_chest.play("opening")
		is_opened = true
	
func _on_large_chest_animation_finished() -> void:
	small_chest.play("open")
