extends ColorRect

func _physics_process(delta: float) -> void:
	var t = get_viewport().get_mouse_position()
	t/=get_viewport_rect().size
	get_material().set_shader_parameter("focusPoint", t)
