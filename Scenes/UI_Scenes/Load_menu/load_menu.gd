extends CanvasLayer
@onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
@onready var hover_sfx: AudioStreamPlayer2D = $HoverSFX
@onready var create_new_file: Control = $CreateNewFile
@onready var load_file: Control = $LoadFile
@onready var yes_button: TextureButton = $CreateNewFile/TextureRect/yes_button
@onready var no_button: TextureButton = $CreateNewFile/TextureRect/no_button
@onready var l_fno_button: TextureButton = $LoadFile/TextureRect/LFno_button
@onready var l_fyes_button: TextureButton = $LoadFile/TextureRect/LFyes_button
@onready var delete_file: Control = $DeleteFile
@onready var d_fyes_button: TextureButton = $"DeleteFile/TextureRect/Delete File?/DFyes_button"
@onready var d_fno_button: TextureButton = $"DeleteFile/TextureRect/Delete File?/DFno_button"

var selected_slot: int = 0

func _ready():
	SceneTransition.animate_entrance()
	update_slots()
	
func update_slots():
	for i in [1, 2, 3]:
		var path = Global.SAVE_PATH + str(i) + ".dat"
		var label_path = "File_Buttons/File_" + str(i) + "/FileLabel" + str(i)
		var label_node = get_node_or_null(label_path)

		if label_node == null:
			push_error("Could not find label at path: " + label_path)
			continue

		if FileAccess.file_exists(path):
			var file = FileAccess.open(path, FileAccess.READ)
			var data = file.get_var()
			file.close()

			var health = data.get("health", 0)
			var stamina = data.get("stamina", 0)
			var time = data.get("timestamp", "Unknown Time")

			label_node.text = "HP: %d  STA: %d\n%s" % [health, stamina, time]
		else:
			label_node.text = "Empty"

			
func delete_save(slot: int) -> void:
	var path = Global.SAVE_PATH + str(slot) + ".dat"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("🗑 Save slot", slot, "deleted.")
		update_slots()

func _on_back_button_pressed() -> void:
	click_sfx.play()
	SceneTransition.animate_exit("res://Scenes/UI_Scenes/Main_menu/title_screen.tscn", "down")
	
func _on_back_button_mouse_entered() -> void:
	hover_sfx.play()

func _on_file_1_pressed() -> void:
	click_sfx.play()
	selected_slot = 1
	Global.selected_save_slot=selected_slot
	if FileAccess.file_exists(Global.SAVE_PATH + str(selected_slot) + ".dat"):
		load_file.visible=true
	else:
		create_new_file.visible=true
	
	
func _on_file_2_pressed() -> void:
	click_sfx.play()
	selected_slot = 2
	Global.selected_save_slot=selected_slot
	if FileAccess.file_exists(Global.SAVE_PATH + str(selected_slot) + ".dat"):
		load_file.visible=true
	else:
		create_new_file.visible=true
	
func _on_file_3_pressed() -> void:
	click_sfx.play()
	selected_slot = 3
	Global.selected_save_slot=selected_slot
	if FileAccess.file_exists(Global.SAVE_PATH + str(selected_slot) + ".dat"):
		load_file.visible=true
	else:
		create_new_file.visible=true

func _on_file_1_mouse_entered() -> void:
	hover_sfx.play()
	
func _on_file_2_mouse_entered() -> void:
	hover_sfx.play()
	
func _on_file_3_mouse_entered() -> void:
	hover_sfx.play()

func _on_yes_button_pressed() -> void:
	click_sfx.play()
	Global.save_game()
	SceneTransition.animate_exit("res://Scenes/GreatForest/Areas/GreenVeil.tscn","down")
	
func _on_no_button_pressed() -> void:
	click_sfx.play()
	create_new_file.visible = false
	
func _on_l_fno_button_pressed() -> void:
	click_sfx.play()
	load_file.visible=false
	
func _on_l_fyes_button_pressed() -> void:
	click_sfx.play()
	Global.load_game()

func _on_yes_button_mouse_entered() -> void:
	hover_sfx.play()
	
func _on_no_button_mouse_entered() -> void:
	hover_sfx.play()

func _on_l_fno_button_mouse_entered() -> void:
	hover_sfx.play()

func _on_l_fyes_button_mouse_entered() -> void:
	hover_sfx.play()

func _on_delete_button_1_pressed() -> void:
	click_sfx.play()
	delete_file.visible = true
	
func _on_delete_button_2_pressed() -> void:
	click_sfx.play()
	delete_file.visible = true

func _on_delete_button_3_pressed() -> void:
	click_sfx.play()
	delete_file.visible = true

func _on_delete_button_1_mouse_entered() -> void:
	hover_sfx.play()
	

func _on_delete_button_2_mouse_entered() -> void:
	hover_sfx.play()

func _on_delete_button_3_mouse_entered() -> void:
	hover_sfx.play()

func _on_d_fyes_button_pressed() -> void:
	click_sfx.play()
	delete_save(selected_slot)
	delete_file.visible = false

func _on_d_fno_button_pressed() -> void:
	delete_file.visible = false

func _on_d_fyes_button_mouse_entered() -> void:
	hover_sfx.play()

func _on_d_fno_button_mouse_entered() -> void:
	hover_sfx.play()
