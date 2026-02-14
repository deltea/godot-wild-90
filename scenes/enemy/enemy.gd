class_name Enemy extends RigidBody2D

const basic_xp_scene = preload("res://scenes/xp/basic_xp.tscn")

var health = 3
var xp_drop = 10

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()
		drop_xp()

func knockback(force: Vector2):
	apply_central_impulse(force)
	apply_torque_impulse(randf_range(-100,100))

func drop_xp():
	for i in xp_drop:
		var xp = basic_xp_scene.instantiate()
		xp.position = position
		RoomManager.current_room.add_child(xp)
