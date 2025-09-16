extends Node2D

@onready var gold_pu: AnimatedSprite2D = $GoldPU



@onready var pickup_sfx: AudioStreamPlayer2D = $pickupSFX
@onready var point_light_2d: PointLight2D = $PointLight2D

@export var amount: int = 1

var can_PU = true

var player_in_range: Player = null
var AnimFinished = false
var SFXFinished= false
func _ready() -> void:
	gold_pu.stop()
	gold_pu.play("ready")

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if not can_PU:
			return
		Inventory.add_gold(amount)
		AlertManager.show_gold_alert(amount)
		pickup_sfx.play()
		gold_pu.play("picked_up")
		point_light_2d.visible = false
		can_PU = false
		
		
func _on_pickup_sfx_finished() -> void:
	queue_free()
