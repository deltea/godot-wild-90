class_name Player extends CharacterBody2D

@export var speed = 20
@export var dashSpeed = 2

var lookingRight = true
var dashTime = 0
var dashing = false
var weaponDir = 1
var health = 100

@onready var anchor := $Anchor
@onready var weaponAnchor := $Anchor/WeaponAnchor
@onready var hitArea := $Anchor/HitArea
@onready var weaponSprite := $Anchor/WeaponAnchor/Sprite2D
@onready var particles := $MoveParticles
@onready var hpBar := $CanvasLayer/hpBar

@onready var weaponRotDynamics: DynamicsSolver = Dynamics.create_dynamics(8.0, 0.8, 2.0)

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	hpBar.value = 100

func _process(dt: float) -> void:
	var dir = (get_global_mouse_position() - position).normalized()
	anchor.rotation = dir.angle() + PI/2
	weaponAnchor.rotation_degrees = weaponRotDynamics.update(weaponDir * 120)

	if Input.is_action_just_pressed("click"):
		weaponDir *= -1
		attack()

func takeDamage(damage):
	health -= damage
	hpBar.value = health

func _physics_process(delta: float) -> void:
	# simple movement
	var input = Input.get_vector("left", "right", "up", "down")
	velocity += input * speed

	if input != Vector2.ZERO:
		particles.emitting = true
	else:
		particles.emitting = false

	# when dashing
	if (dashTime > 7 || dashing == false):
		velocity *= 0.8
	if (Input.is_action_just_pressed("right")):
		lookingRight = true
	if (Input.is_action_just_pressed("left")):
		lookingRight = false
	$Sprite.flip_h = !lookingRight
	if (Input.is_action_just_pressed("dash") && dashing == false):
		dashing = true

	if (dashing == true):
		if (dashTime == 0):
			velocity *= dashSpeed
		dashTime += 1
	if (dashTime == 40):
		dashTime = 0
		dashing = false

	if (dashing == true && dashTime <= 15):
		$Sprite.self_modulate.a = 0.5
	else:
		$Sprite.self_modulate.a = 1
	
	if velocity.length() < 3:
		$playerAnimations.play("idle")
	else:
		$playerAnimations.play("walking")

	move_and_slide()

func attack():
	var collisions = hitArea.get_overlapping_bodies()
	for body in collisions:
		if not body is Enemy: continue
		var dist = body.position.distance_to(weaponSprite.global_position)

		await Clock.wait(dist / 2000.0)

		Clock.hitstop(0.07)
		# RoomManager.current_room.camera.shake(0.5, 5)
		RoomManager.current_room.camera.jerk_direction(position - get_global_mouse_position(), 5.0)
		body.knockback((body.position - global_position).normalized() * 200)
		body.take_damage(1)

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area is XP:
		area.queue_free()
