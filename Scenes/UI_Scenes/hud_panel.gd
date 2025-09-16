extends TextureRect

@onready var gesture_trail: Line2D = $GestureTrail
@onready var panel_container: PanelContainer = $PanelContainer

func _ready():
	GestureManager.configure(panel_container, gesture_trail)
