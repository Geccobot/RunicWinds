extends ProgressBar
class_name ManaBar

var mana: int = 0 : set = _set_mana

func _set_mana(new_mana: int) -> void:
	mana = clamp(new_mana, 0, max_value)
	value = mana

func init_mana(max_mana: int) -> void:
	mana = max_mana
	max_value = max_mana
	value = max_mana
