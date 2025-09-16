extends GPUParticles2D
@onready var point_light_2d: PointLight2D = $PointLight2D


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if emitting == true:
		point_light_2d.visible = true
	else:
		point_light_2d.visible = false
