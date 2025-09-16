# Hurtbox.gd
extends Area2D
class_name Hurtbox

@export var hurtbox_owner: Node = null
signal hurt(damage: int, from: Node)

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitbox"):
		return

	var dmg := 0
	var attacker: Node = null

	if area.has_method("get"):  # defensive
		dmg = int(area.get("damage"))
		attacker = area.get("Boxowner")

	# Ignore self
	if attacker == hurtbox_owner:
		return

	emit_signal("hurt", dmg, attacker)
