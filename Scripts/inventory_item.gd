extends TextureButton
@onready var click_sfx: AudioStreamPlayer = $SFX/ClickSFX
@onready var hover_sfx: AudioStreamPlayer = $SFX/HoverSFX
@onready var pause_sfx: AudioStreamPlayer = $SFX/PauseSFX
@onready var unpause_sfx: AudioStreamPlayer = $SFX/UnpauseSFX

@onready var inventory_item: TextureButton = $"."


func _on_pressed() -> void:
	click_sfx.play()
func _on_mouse_entered() -> void:
	hover_sfx.play()
