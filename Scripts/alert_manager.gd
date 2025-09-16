# AlertManager.gd (autoload)
extends Node

@onready var alert_panel: CanvasLayer = $AlertPanel
@onready var gold_alert_panel: CanvasLayer = $GoldAlertPanel
@onready var gold_label: Label = $GoldAlertPanel/GoldLabel
@onready var animated_sprite_2d: AnimatedSprite2D = $GoldAlertPanel/AnimatedSprite2D
@onready var area_panel: CanvasLayer = $AreaPanel
@onready var area_label: Label = $AreaPanel/AreaLabel

var fade_tween: Tween
var gold_tween: Tween
var area_tween: Tween

func _ready():
	# Setup regular alerts
	alert_panel.layer = 50
	alert_panel.visible = false

	# Setup gold alerts
	gold_alert_panel.layer = 60  # ensure it's above regular panel
	gold_label.visible = false
	gold_label.modulate.a = 0.0
	animated_sprite_2d.visible = false
	area_label.visible = false
	area_panel.layer = 50
# Regular item alert (Panel)
func show_alert(text: String, duration := 2.0):
	var panel := alert_panel.get_node("Panel") as Panel
	var label := panel.get_node("Label") as Label

	label.text = text
	alert_panel.visible = true
	panel.modulate = Color(1,1,1,1)

	if fade_tween: fade_tween.kill()
	fade_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fade_tween.tween_interval(duration)
	fade_tween.tween_property(panel, "modulate:a", 0.0, 0.7)
	fade_tween.finished.connect(func(): alert_panel.visible = false)

# Gold alert (Label only)
func show_gold_alert(amount: int, duration :=20, fade_time := 1):
	print("%d gold picked up" % amount)
	gold_label.text = "+%d" % amount
	gold_label.visible = true
	animated_sprite_2d.visible = true
	gold_label.modulate.a = 1.0
	animated_sprite_2d.modulate.a = 1.0

	if gold_tween:
		gold_tween.kill()

	gold_tween = get_tree().create_tween()
	gold_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# hold longer, then fade both in parallel—more slowly
	gold_tween.tween_interval(duration)
	gold_tween.parallel().tween_property(gold_label, "modulate:a", 0.0, fade_time)
	gold_tween.parallel().tween_property(animated_sprite_2d, "modulate:a", 0.0, fade_time)

	gold_tween.finished.connect(func():
		gold_label.visible = false
		animated_sprite_2d.visible = false)
		
func show_name_alert( name: String, duration:= 2, fade_time:=1):
	area_label.text ="-%s-" %name
	area_label.visible = true
	area_label.modulate.a = 1.0
	
	if area_tween:
		area_tween.kill()
		
	area_tween = get_tree().create_tween()
	area_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	area_tween.tween_interval(duration)
	area_tween.tween_property(area_label, "modulate:a", 0.0, fade_time)
	area_tween.finished.connect(func(): area_label.visible = false)
	
