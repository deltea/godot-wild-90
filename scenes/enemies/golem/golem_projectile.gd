class_name Projectile extends Area2D

var playerDir = Vector2.ZERO
var speed = 5
# Called when the node enters the scene tree for the first time.
func initializeVals():
	playerDir = (RoomManager.current_room.get_node("Player").position-position).normalized()

func _physics_process(delta: float) -> void:
	position+=playerDir*speed
	speed *= 0.98
	
func blowUp():
	queue_free()

func _on_timer_timeout() -> void:
	blowUp()
