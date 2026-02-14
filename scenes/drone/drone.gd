class_name Drone extends CharacterBody2D

const mask_scene = preload("res://scenes/mask/mask.tscn")

@export var max_speed = 80.0
@export var deceleration = 100.0
@export var acceleration = 100.0

@onready var pivot: Node2D = $Pivot
@onready var raycast: RayCast2D = $Pivot/RayCast2D

var can_move = false

func _enter_tree() -> void:
	RoomManager.current_room.drone = self

func _process(dt: float) -> void:
	var dir = (get_global_mouse_position() - position).normalized()
	pivot.rotation = dir.angle() - PI/2

	if Input.is_action_just_pressed("click") and raycast.is_colliding():
		var mask = mask_scene.instantiate() as PointLight2D
		mask.position = raycast.get_collision_point()
		RoomManager.current_room.add_child(mask)

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	if input != Vector2.ZERO and can_move:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	move_and_slide()
