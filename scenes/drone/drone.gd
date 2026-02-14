class_name Drone extends CharacterBody2D

@export var max_speed = 80.0
@export var deceleration = 100.0
@export var acceleration = 100.0

@onready var pivot: Node2D = $Pivot

var can_move = false

func _enter_tree() -> void:
	RoomManager.current_room.drone = self

func _process(dt: float) -> void:
	var dir = (get_global_mouse_position() - position).normalized()
	pivot.rotation = dir.angle() - PI/2

func _physics_process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	move_and_slide()
