extends CanvasLayer
@onready var back_button: TextureButton = $Panel/BackButton
@onready var equipment_button: TextureButton = $Panel/EquipmentButton
@onready var inventory_button: TextureButton = $Panel/InventoryButton
@onready var status_button: TextureButton = $Panel/StatusButton
@onready var quest_log_button: TextureButton = $Panel/QuestLogButton
@onready var map_button: TextureButton = $Panel/MapButton
@onready var quit_game_button: TextureButton = $Panel/QuitGameButton
@onready var map_panel: Panel = $Map_Panel
@onready var main_panel: Panel = $Main_Panel
@onready var quit_confirm: Panel = $Main_Panel/Quit_Confirm
@onready var qg_yes_button: TextureButton = $Main_Panel/Quit_Confirm/QGYesButton
@onready var qg_no_button: TextureButton = $Main_Panel/Quit_Confirm/QGNoButton
@onready var click_sfx: AudioStreamPlayer = $SFX/ClickSFX
@onready var hover_sfx: AudioStreamPlayer = $SFX/HoverSFX
@onready var pause_sfx: AudioStreamPlayer = $SFX/PauseSFX
@onready var unpause_sfx: AudioStreamPlayer = $SFX/UnpauseSFX
@onready var inventory_panel: Panel = $InventoryPanel
@onready var all_button: TextureButton = $InventoryPanel/AllButton
@onready var key_items_button: TextureButton = $InventoryPanel/KeyItemsButton
@onready var key_items: Label = $InventoryPanel/KeyItemsButton/KeyItems
@onready var aid_button: TextureButton = $InventoryPanel/AidButton
@onready var equip_button: TextureButton = $InventoryPanel/EquipButton
@onready var equipment: Label = $InventoryPanel/EquipButton/Equipment
@onready var inventory: Label = $InventoryPanel/Inventory
@onready var inventory_list_panel: Panel = $InventoryPanel/InventoryListPanel
@onready var scroll_container: ScrollContainer = $InventoryPanel/InventoryListPanel/ScrollContainer
@onready var inventory_list: VBoxContainer = $InventoryPanel/InventoryListPanel/ScrollContainer/InventoryList
@onready var item_descrition_panel: Panel = $InventoryPanel/ItemDescritionPanel
@onready var inventorybackbutton: TextureButton = $InventoryPanel/Inventorybackbutton
@onready var item: TextureButton = $InventoryPanel/InventoryListPanel/ScrollContainer/InventoryList/Item
@onready var gold_label: Label = $InventoryPanel/GoldLabel


var default_cursor = load("res://Assets/Sprites/GamePlay/default_cursor.png")
var magic_cursor = load("res://Assets/Sprites/GamePlay/Cursor.png")

func _ready() -> void:
	# Update immediately and listen for changes
	gold_label.text = "%d" % Inventory.gold
	Inventory.gold_changed.connect(_on_gold_changed)

func _on_gold_changed(new_amount: int) -> void:
	gold_label.text = "%d" % new_amount


func pause_game()-> void:
		MusicManager.music_player.volume_db = -8
		pause_sfx.play()
		get_tree().paused = true
		Input.set_custom_mouse_cursor(default_cursor, 0, Vector2(0,0))
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		PauseMenu.visible=true

func _on_back_button_pressed() -> void:
	MusicManager.music_player.volume_db = 0.0
	unpause_sfx.play()
	get_tree().paused = false
	PauseMenu.visible = false
	Input.set_custom_mouse_cursor(magic_cursor, 0 , Vector2(0,0))
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
func _on_back_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_equipment_button_pressed() -> void:
	click_sfx.play()
func _on_equipment_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_inventory_button_pressed() -> void:
	inventory_panel.visible = true
	main_panel.visible = false
	click_sfx.play()
func _on_inventory_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_inventorybackbutton_pressed() -> void:
	click_sfx.play()
	main_panel.visible = true
	inventory_panel.visible= false
func _on_inventorybackbutton_mouse_entered() -> void:
	hover_sfx.play()
func _on_all_button_pressed() -> void:
	click_sfx.play()
func _on_all_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_key_items_button_pressed() -> void:
	click_sfx.play()
func _on_key_items_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_aid_button_pressed() -> void:
	click_sfx.play()
func _on_aid_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_equip_button_pressed() -> void:
	click_sfx.play()
func _on_equip_button_mouse_entered() -> void:
	hover_sfx.play()


func _on_status_button_pressed() -> void:
	click_sfx.play()
func _on_status_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_quest_log_button_pressed() -> void:
	click_sfx.play()
func _on_quest_log_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_map_button_pressed() -> void:
	main_panel.visible = false
	map_panel.visible = true
	click_sfx.play()
func _on_map_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_mapbackbutton_pressed() -> void:
	click_sfx.play()
	main_panel.visible = true
	map_panel.visible = false
func _on_mapbackbutton_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_quit_game_button_pressed() -> void:
	click_sfx.play()
	quit_confirm.visible = true
func _on_quit_game_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func _on_qg_yes_button_pressed() -> void:
	unpause_sfx.play()
	PauseMenu.visible=false
	quit_confirm.visible=false
	get_tree().paused=false
	SceneTransition.animate_exit("res://Scenes/UI_Scenes/Main_menu/title_screen.tscn","down")
func _on_qg_no_button_pressed() -> void:
	click_sfx.play()
	quit_confirm.visible = false
func _on_qg_no_button_mouse_entered() -> void:
	hover_sfx.play()
func _on_qg_yes_button_mouse_entered() -> void:
	hover_sfx.play()
	
	
func open_inventory() -> void:
	pause_game()
	inventory_panel.visible= true
	main_panel.visible = false
