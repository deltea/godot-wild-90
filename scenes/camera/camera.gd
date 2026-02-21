class_name Camera extends Camera2D

@export var follow: Node2D
@export var follow_enabled = false
@export var follow_speed = 3.0
# @export var player_strength = 0.1
@export var tilt_magnitude = 0
@export var impact_rotation = 1.0
@export var shake_damping_speed = 1.0
@export var jerk_damping_speed = 150.0

var shake_duration = 0.0;
var shake_magnitude = 0.0;
var shake_offset = Vector2.ZERO
var player_offset = Vector2.ZERO
var target_jerk = Vector2.ZERO
var jerk = Vector2.ZERO
var tilt_impact_dir = 1

func _enter_tree() -> void:
	RoomManager.current_room.camera = self

func _process(delta: float) -> void:
	# if RoomManager.current_room.player:
	# 	if follow_enabled:
	# 		position = position.lerp(RoomManager.current_room.player.position, follow_speed * delta)
	# 	else:
	# 		rotation_degrees = -(RoomManager.current_room.player.position.x - position.x) * tilt_magnitude
	jerk = jerk.move_toward(target_jerk, jerk_damping_speed * delta)

	if follow_enabled:
		position = position.lerp(follow.position, follow_speed * delta)

	if shake_duration > 0:
		shake_offset = Vector2.from_angle(randf_range(0, PI*2)) * shake_magnitude
		shake_duration -= delta * shake_damping_speed
	else:
		shake_duration = 0
		shake_offset = Vector2.ZERO

	# if RoomManager.current_room.player:
	# 	player_offset = RoomManager.current_room.player.global_position * player_strength
	offset = shake_offset + player_offset + jerk

func shake(duration: float, magnitude: float):
	shake_duration = duration
	shake_magnitude = magnitude

func jerk_direction(direction: Vector2, magnitude: float):
	target_jerk = direction.normalized() * magnitude
	await Clock.wait(0.1)
	target_jerk = Vector2.ZERO

func tilt_impact():
	rotation_degrees = impact_rotation * tilt_impact_dir
	await Clock.wait(0.08)
	rotation_degrees = 0
	tilt_impact_dir = -tilt_impact_dir
