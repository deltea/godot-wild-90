class_name UpgradeCard extends PanelContainer

@export var float_speed = 2

@onready var position_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.8, 2)
@onready var rotation_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.8, 2)

var offset = 0
var is_hovering = false

func _process(dt: float) -> void:
	var target_y = position.y
	var target_rot = rotation_degrees
	if is_hovering:
		target_y = -10
		target_rot = 4 * (offset - 1)
	else:
		target_y = sin(Clock.time * float_speed + (2 * offset)) * 3
		target_rot = 0

	position.y = position_dynamics.update(target_y)
	rotation_degrees = rotation_dynamics.update(target_rot)

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false
