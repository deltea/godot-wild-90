class_name Projectile extends Area2D

var playerDir = Vector2.ZERO
var speed = 4
var parabolicOffset = 0
var t = 0
var explosion = preload("res://scenes/particles/enemy_explosion.tscn")
# Called when the node enters the scene tree for the first time.
func initializeVals():
	playerDir = (RoomManager.current_room.get_node("Player").position-position).normalized()

func _physics_process(delta: float) -> void:
	t+=0.02
	parabolicOffset = pow(6,2)-pow(t-6,2)
	position+=playerDir*speed
	speed *= 0.985
	$Circle512.position.y=parabolicOffset
	
func blowUp():
	var exp = explosion.instantiate() as CPUParticles2D
	exp.position = position
	exp.emitting = true
	RoomManager.current_room.add_child(exp)
	queue_free()

func _on_timer_timeout() -> void:
	blowUp()
