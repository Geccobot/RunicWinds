extends Node
class_name Combat
@onready var death_timer: Timer = $"../DeathTimer"
@onready var resources: Resources = $"../Resources"

func take_damage(amount: int, from: Node) -> void:
	resources.take_damage(amount, from)

	if resources.health <= 0:
		death_timer.start()

func die() -> void:
	print(owner.name, " has died")
	owner.queue_free()


func _on_death_timer_timeout() -> void:
	die()
