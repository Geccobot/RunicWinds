extends VBoxContainer

@export var item_picture_panel: TextureRect
@export var item_name: Label
@export var description_label: Label

@onready var item_scene = preload("res://Scenes/Global_Scenes/inventory_item.tscn")

var item_entries: Dictionary = {} # { id: Control }

func _ready() -> void:
	Inventory.item_added.connect(_on_item_added)
	Inventory.item_updated.connect(_on_item_updated)

	for item: ItemData in Inventory.get_items():
		var amt: int = Inventory.get_amount(item.id)
		_on_item_added(item, amt)

func _on_item_added(item: ItemData, amount: int) -> void:
	var entry = item_scene.instantiate()
	var label: Label = entry.get_node("Label")
	label.text = "%s x%d" % [item.display_name, amount]
	item_entries[item.id] = entry
	add_child(entry)

	if entry is BaseButton:
		entry.pressed.connect(func():
			_show_item_details(item))

func _on_item_updated(item: ItemData, amount: int) -> void:
	if item.id in item_entries:
		var entry = item_entries[item.id]
		var label: Label = entry.get_node("Label")
		label.text = "%s x%d" % [item.display_name, amount]

func _show_item_details(item: ItemData) -> void:
	item_name.text = item.display_name
	description_label.text = item.description
	item_picture_panel.texture = item.icon
