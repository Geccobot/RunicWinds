extends Node2D
@onready var player: Player = $World_Objects/Player
@onready var timer: Timer = $Timer
@onready var name_panel: CanvasLayer = $NamePanel

func _ready():
	AlertManager.show_name_alert("Green Veil")
	SceneTransition.animate_entrance()
