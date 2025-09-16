# res://Scripts/Data/ItemData.gd
extends Resource
class_name ItemData

# A short, unique identifier you’ll use internally (must be unique)
@export var id: StringName

# What the player sees
@export var display_name: String
@export var icon: Texture2D
@export_multiline var description: String

# Optional extras
@export var max_stack: int = 99
@export var type: StringName = &"keyitem"  # armor, weapon, key, etc.
