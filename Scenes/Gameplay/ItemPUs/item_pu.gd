extends Node2D

@onready var item_pu: AnimatedSprite2D = $ItemPU
@onready var pickup_sfx: AudioStreamPlayer2D = $pickupSFX
@onready var point_light_2d: PointLight2D = $PointLight2D

@export var item: ItemData
@export var amount: int = 1

var can_PU= true

var player_in_range: Player = null
var AnimFinished = false
var SFXFinished= false
func _ready() -> void:
	item_pu.stop()
	item_pu.play("ready")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = body
		player_in_range.set_interactable(self)
		

func _on_interactable_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range.set_interactable(null)
		player_in_range = null

func interact() -> void:
	if not can_PU:
		return
	Inventory.add_item(item, amount)
	AlertManager.show_alert("Picked up %d x %s" % [amount, item.display_name])
	pickup_sfx.play()
	item_pu.play("picking_up")
	point_light_2d.visible = false
	can_PU = false
		
		
func _on_pickup_sfx_finished() -> void:
	queue_free()


	

		
