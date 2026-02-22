class_name UpgradeCard extends Control

const attribute_names = ["health", "speed", "dash speed", "atk speed"]

@export var float_speed = 2
@export var health_icon: Texture2D
@export var speed_icon: Texture2D
@export var dash_speed_icon: Texture2D
@export var attack_speed_icon: Texture2D
@export var border_1: Texture2D
@export var border_2: Texture2D
@export var border_3: Texture2D

@onready var label := $NinePatchRect/CenterContainer/HBoxContainer/Label
@onready var icon := $NinePatchRect/CenterContainer/HBoxContainer/Icon
@onready var border := $Border
@onready var position_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.8, 2)
@onready var rotation_dynamics: DynamicsSolver = Dynamics.create_dynamics(4, 0.8, 2)

var offset = 0
var is_hovering = false
var shadow: TextureRect
var attribute = 0
var magnitude = 0

func _ready() -> void:
	label.text = "[wave freq=2]" + attribute_names[attribute] + "[/wave]" + "\n\n--- +" + str(magnitude) + " ---"

	match magnitude:
		1: border.texture = border_1
		2: border.texture = border_2
		3: border.texture = border_3

	match attribute:
		0: icon.texture = health_icon
		1: icon.texture = speed_icon
		2: icon.texture = dash_speed_icon
		3: icon.texture = attack_speed_icon

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

	if shadow:
		shadow.scale = Vector2.ONE * (1 + position.y / 150.0)

func _on_mouse_entered() -> void:
	is_hovering = true

func _on_mouse_exited() -> void:
	is_hovering = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		RoomManager.current_room.player.levelUp(attribute, magnitude)
		RoomManager.upgrade_panel.finish_upgrade()
