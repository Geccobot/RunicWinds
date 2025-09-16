extends CanvasLayer
@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
@onready var hover_sfx: AudioStreamPlayer2D = $HoverSFX

var default_cursor = load("res://Assets/Sprites/GamePlay/default_cursor.png")

func _ready() -> void:
	SceneTransition.animate_entrance()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(default_cursor, 0, Vector2(0,0))

func _on_new_game_pressed() -> void:
	click_sfx.play()
	SceneTransition.animate_exit("res://Scenes/UI_Scenes/Load_menu/load_menu.tscn","down")
	


func _on_continue_pressed() -> void:
	click_sfx.play()
	SceneTransition.animate_exit("res://Scenes/UI_Scenes/Load_menu/load_menu.tscn","down")
	

func _on_exit_pressed() -> void:
	click_sfx.play()
	get_tree().quit()


func _on_new_game_mouse_entered() -> void:
	hover_sfx.play()


func _on_continue_mouse_entered() -> void:
	hover_sfx.play()


func _on_exit_mouse_entered() -> void:
	hover_sfx.play()
