extends Node
class_name Resources

signal health_changed(new_health: int)
signal stamina_changed(new_stamina: int)
signal mana_changed(new_mana: int)

@export var max_health: int = 100
@export var health: int = 100

@export var max_stamina: int = 50
@export var stamina: int = 50
@export var stamina_regen_rate: int = 4
@export var stamina_regen_delay: float = 0.5

@export var max_mana: int = 30
@export var mana: int = 30
@export var mana_regen_amount: int = 1
@export var mana_regen_interval: float = 1.5

# If these nodes exist as children, they'll bind; otherwise we'll create them.
@onready var stam_regen_timer: Timer = $StamRegenTimer
@onready var delay_timer: Timer = $DelayTimer
@onready var mana_regen_timer: Timer = $ManaRegenTimer

func _ready() -> void:
	# ---- Stamina Timers ----
	if stam_regen_timer == null:
		stam_regen_timer = Timer.new()
		stam_regen_timer.name = "StamRegenTimer"
		add_child(stam_regen_timer)
	stam_regen_timer.wait_time = 0.5
	stam_regen_timer.one_shot = false
	if not stam_regen_timer.timeout.is_connected(_on_regen_timer_timeout):
		stam_regen_timer.timeout.connect(_on_regen_timer_timeout)

	if delay_timer == null:
		delay_timer = Timer.new()
		delay_timer.name = "DelayTimer"
		add_child(delay_timer)
	delay_timer.one_shot = true
	delay_timer.wait_time = stamina_regen_delay
	if not delay_timer.timeout.is_connected(_on_delay_timer_timeout):
		delay_timer.timeout.connect(_on_delay_timer_timeout)

	# ---- Mana Timer ----
	if mana_regen_timer == null:
		mana_regen_timer = Timer.new()
		mana_regen_timer.name = "ManaRegenTimer"
		add_child(mana_regen_timer)
	mana_regen_timer.wait_time = mana_regen_interval
	mana_regen_timer.one_shot = false
	if not mana_regen_timer.timeout.is_connected(_on_mana_regen_timeout):
		mana_regen_timer.timeout.connect(_on_mana_regen_timeout)

	calculate_resources()

func calculate_resources() -> void:
	health = max_health
	stamina = max_stamina
	mana = max_mana
	emit_signal("health_changed", health)
	emit_signal("stamina_changed", stamina)
	emit_signal("mana_changed", mana)

# -------- Health --------
func take_damage(amount: int, _from: Node = null) -> void:
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health)

func heal(amount: int) -> void:
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health)

# -------- Stamina --------
func spend_stamina(amount: int) -> bool:
	if stamina >= amount:
		stamina -= amount
		emit_signal("stamina_changed", stamina)
		stam_regen_timer.stop()
		delay_timer.start()
		return true
	return false

func restore_stamina(amount: int) -> void:
	stamina = clamp(stamina + amount, 0, max_stamina)
	emit_signal("stamina_changed", stamina)

func _on_delay_timer_timeout() -> void:
	if stamina < max_stamina:
		stam_regen_timer.start()

func _on_regen_timer_timeout() -> void:
	if stamina < max_stamina:
		stamina = clamp(stamina + stamina_regen_rate, 0, max_stamina)
		emit_signal("stamina_changed", stamina)
	else:
		stam_regen_timer.stop()

# -------- Mana --------
func use_mana(amount: int) -> bool:
	if mana >= amount:
		mana -= amount
		emit_signal("mana_changed", mana)
		mana_regen_timer.stop()
		mana_regen_timer.start()
		return true
	return false

func restore_mana(amount: int) -> void:
	if amount <= 0:
		return
	mana = clamp(mana + amount, 0, max_mana)
	emit_signal("mana_changed", mana)

func _on_mana_regen_timeout() -> void:
	if mana < max_mana:
		mana = clamp(mana + mana_regen_amount, 0, max_mana)
		emit_signal("mana_changed", mana)
	else:
		mana_regen_timer.stop()
