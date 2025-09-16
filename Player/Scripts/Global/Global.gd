extends Node

const SAVE_PATH: = "user://save_slot_"
var selected_save_slot: int
var player_health: int = 100
var player_max_health: int = 100
var player_max_stamina: int = 100
var player_stamina: int = 100

var activated_waypoints = {}

func activate_waypoint(id: String)-> void:
	activated_waypoints[id] = true
	
func is_waypoint_activated(id: String)-> bool:
	return activated_waypoints.get(id, false)
	
func save_game():
	var data = {
		"health": player_health,
		"max_health": player_max_health,
		"Stamina": player_stamina,
		"max_stamina": player_max_stamina,
		"timestamp": Time.get_datetime_string_from_system()
	}
	var file = FileAccess.open(SAVE_PATH + str(selected_save_slot) + ".dat", FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()
		print("Game saved to slot", selected_save_slot)
	else:
		print("Could not open file for saving.")
		
func load_game():
	var path = SAVE_PATH + str(selected_save_slot) + ".dat"
	if not FileAccess.file_exists(path):
		print("Save file does not exist.")
		return
	var file = FileAccess.open(path,FileAccess.READ)
	if file:
		var data = file.get_var()
		file.close()
		
		player_health = data.get("health", 100)
		player_max_health = data.get("max_health", 100)
		player_stamina = data.get("stamina", 100)
		player_max_stamina = data.get("max_stamina", 100)
		activated_waypoints = data.get("waypoints", {})
		
		print("Game loaded from slot", selected_save_slot)
	else:
		print("Could not open file for loading.")
		
