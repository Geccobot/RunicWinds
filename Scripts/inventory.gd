# res://Scripts/Singletons/Inventory.gd (autoload)
extends Node

signal item_added(item: ItemData, amount: int)
signal item_updated(item: ItemData, amount: int)
signal item_removed(item: ItemData)
signal gold_changed(new_amount: int)

var gold: int = 0
# Typed dictionaries (id -> amount / id -> data)
var amounts: Dictionary[StringName, int] = {}
var db: Dictionary[StringName, ItemData] = {}

func add_gold(amount: int) -> void:
	if amount <= 0: return
	gold += amount
	gold_changed.emit(gold)
	
func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		gold_changed.emit(gold)
		return true
	return false

func add_item(item: ItemData, amount: int = 1) -> void:
	if item == null:
		push_error("Inventory.add_item: item is null")
		return
	if item.id == &"": # empty StringName
		push_error("Inventory.add_item: ItemData.id must be set")
		return

	db[item.id] = item
	var current: int = amounts.get(item.id, 0)
	var new_amount: int = current + amount
	var was_new: bool = not amounts.has(item.id)
	amounts[item.id] = new_amount

	if was_new:
		item_added.emit(item, new_amount)
	else:
		item_updated.emit(item, new_amount)

func get_amount(item_id: StringName) -> int:
	return int(amounts.get(item_id, 0))

func remove_item(item_id: StringName, amount: int = 1) -> void:
	var cur: int = int(amounts.get(item_id, 0))
	if cur <= 0:
		return

	var next: int = max(cur - amount, 0)
	if next == 0:
		var item: ItemData = db.get(item_id, null) as ItemData
		amounts.erase(item_id)
		db.erase(item_id)
		if item != null:
			item_removed.emit(item)
	else:
		amounts[item_id] = next
		var item2: ItemData = db.get(item_id, null) as ItemData
		if item2 != null:
			item_updated.emit(item2, next)

func get_items() -> Array[ItemData]:
	var items: Array[ItemData] = []
	for id in db.keys():
		items.append(db[id])
	return items
