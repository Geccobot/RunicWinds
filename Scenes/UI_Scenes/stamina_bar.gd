extends ProgressBar
class_name StaminaBar

@onready var ghost_bar: ProgressBar = $GhostBar

var stamina: int = 0 : set = _set_stamina

func _set_stamina(new_stamina: int) -> void:
	var prev = stamina
	stamina = clamp(new_stamina, 0, max_value)

	# Animate main bar
	var main_tween = get_tree().create_tween()
	main_tween.tween_property(self, "value", stamina, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Animate ghost bar
	if stamina < prev:
		var ghost_tween = get_tree().create_tween()
		ghost_tween.tween_property(ghost_bar, "value", stamina, 0.5)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		ghost_bar.value = stamina


func init_stamina(max_stamina: int) -> void:
	stamina = max_stamina
	max_value = max_stamina
	value = max_stamina
	ghost_bar.max_value = max_stamina
	ghost_bar.value = max_stamina
