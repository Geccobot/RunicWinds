extends ProgressBar
class_name HealthBar

@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer

var health: int = 0 : set = _set_health

func _set_health(new_health: int) -> void:
	var prev = health
	health = clamp(new_health, 0, max_value)
	value = health

	# Animate delayed bar only when taking damage
	if health < prev:
		timer.start()
	else:
		damage_bar.value = health

func init_health(max_health: int) -> void:
	health = max_health
	max_value = max_health
	value = max_health
	damage_bar.max_value = max_health
	damage_bar.value = max_health

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(damage_bar, "value", health, 0.75)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
