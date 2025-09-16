extends Node

@export var spell_scenes: Dictionary = {
	"fireball": preload("res://Scenes/Gameplay/Combat/fire_ball.tscn"),
}

func cast_spell(spell_name: String, position: Vector2, direction: Vector2, owner: Node):
	if not spell_scenes.has(spell_name):
		print("Unknown spell:", spell_name)
		return
	
	var spell_scene = spell_scenes[spell_name]
	var spell_instance = spell_scene.instantiate()

	spell_instance.global_position = position
	spell_instance.set("direction", direction)
	spell_instance.set("caster", owner)     # ✅ Add this line
	spell_instance.set("Boxowner", owner)   # Optional if your spell uses Hitbox

		# Adjust this path if needed:
	var ysort_node = get_tree().current_scene.get_node("World_Objects")

	if ysort_node:
		ysort_node.add_child(spell_instance)
	else:
		get_tree().current_scene.add_child(spell_instance)  # Fallback in case not found
