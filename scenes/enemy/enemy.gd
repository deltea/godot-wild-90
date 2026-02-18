class_name Enemy extends RigidBody2D

const basic_xp_scene = preload("res://scenes/xp/basic_xp.tscn")
const big_xp_scene = preload("res://scenes/xp/big_xp.tscn")
const explosion_scene = preload("res://scenes/particles/enemy_explosion.tscn")

@export var xpDropMin = 8
@export var xpDropMax = 15
@export var damage = 10

var health = 3
var xp_drop = 0

func _ready() -> void:
	xp_drop = randi_range(xpDropMin, xpDropMax)

func take_damage(damage: int):
	health -= damage
	if health <= 0: die()

func die():
	queue_free()
	drop_xp()
	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	RoomManager.current_room.add_child(explosion)
	RoomManager.current_room.camera.shake(0.1, 2)

func knockback(force: Vector2):
	apply_central_impulse(force)
	apply_torque_impulse(randf_range(-100,100))

func drop_xp():
	# drops as many big xp as possible, then drops basic xp for the rest
	# ex. 12 would drop 2 big xp and 2 basic xp
	var big_xp_count = xp_drop / 5
	var basic_xp_count = xp_drop % 5
	for i in big_xp_count + basic_xp_count:
		var scene = big_xp_scene if i < big_xp_count else basic_xp_scene
		var xp = scene.instantiate() as XP
		xp.position = position
		RoomManager.current_room.add_child(xp)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.takeDamage(damage)
		knockback((position - body.position).normalized() * 200)
