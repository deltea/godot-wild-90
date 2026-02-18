class_name XP extends Area2D

@export var value = 1

var velocity = Vector2.ZERO
var speed = 500
var attractSpeed = 400
var isAttracted = false

func _ready() -> void:
	var dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	velocity = dir * 350
	await Clock.wait(0.75)
	isAttracted = true

func _process(dt: float) -> void:
	if isAttracted:
		# move towards the player
		speed += attractSpeed * dt
		if RoomManager.current_room.player:
			var player_pos = RoomManager.current_room.player.position
			var dir = (player_pos - position).normalized()
			velocity += dir * speed * dt

func _physics_process(delta):
	position += velocity * delta
	velocity *= 0.9
