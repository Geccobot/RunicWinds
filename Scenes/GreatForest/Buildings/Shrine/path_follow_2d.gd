extends PathFollow2D

@export var speed: float = 15.0 # Speed in pixels per second

func _process(delta: float) -> void:
	# Update the progress along the path
	# 'progress' is in pixels, 'progress_ratio' is a 0-1 float
	progress += speed * delta
