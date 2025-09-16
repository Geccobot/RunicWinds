extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
var current_track: String = ""
var last_scene_path := ""

var scene_music = {
	"res://Scenes/UI_Scenes/Load_menu/load_menu.tscn": "res://Assets/music/Runic Winds -title theme.wav",
	"res://Scenes/UI_Scenes/Main_menu/title_screen.tscn": "res://Assets/music/Runic Winds -title theme.wav",
	"res://Scenes/GreatForest/Areas/GreenVeil.tscn": "res://Assets/music/Green Veil.wav",
	"res://Scenes/GreatForest/Areas/deep_wood.tscn": "res://Assets/music/DeepWood.wav",
	"res://Scenes/GreatForest/Areas/great_forest.tscn": "res://Assets/music/Green Veil.wav",
	"res://Scenes/GreatForest/Areas/house_1_int.tscn": "res://Assets/music/Green Veil.wav",
	"res://Scenes/GreatForest/Areas/black_smith_int.tscn": "res://Assets/music/Green Veil.wav"
}

func _process(delta):
	var current_scene = get_tree().current_scene
	if current_scene:
		var path = current_scene.scene_file_path
		if path != last_scene_path:
			last_scene_path = path
			if scene_music.has(path):
				play_music(scene_music[path])
			else:
				stop_music()

func play_music(stream_path: String):
	if current_track == stream_path:
		return
	current_track = stream_path
	music_player.stream = load(stream_path)
	music_player.play()

func stop_music():
	current_track = ""
	music_player.stop()
