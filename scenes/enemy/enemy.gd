class_name Enemy extends RigidBody2D

var health = 30

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()

func knockback(force: Vector2):
	apply_central_impulse(force)
	apply_torque_impulse(randf_range(-100,100))
