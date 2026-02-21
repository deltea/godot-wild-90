class_name Player extends CharacterBody2D

@export var speed = 20
@export var dashSpeed = 2

var lookingRight = true
var dashTime = 0
var dashing = false
var weaponDir = 1
var health = 100
var isInvincible = false
var xp = 0
var maxXp = 20

@onready var anchor := $Anchor
@onready var weaponAnchor := $Anchor/WeaponAnchor
@onready var hitArea := $Anchor/HitArea
@onready var weaponSprite := $Anchor/WeaponAnchor/Sprite2D
@onready var particles := $MoveParticles
@onready var hpBar := $CanvasLayer/hpBar
@onready var collider := $CollisionShape2D
@onready var sprite := $SpriteContainer/Sprite

@onready var weaponRotDynamics: DynamicsSolver = Dynamics.create_dynamics(8.0, 0.8, 2.0)
@onready var spriteScaleDynamics: DynamicsSolverVector = Dynamics.create_dynamics_vector(2.0, 0.5, 2.0)

func _enter_tree() -> void:
	RoomManager.current_room.player = self

func _ready() -> void:
	hpBar.value = 100

func _process(dt: float) -> void:
	var dir = (get_global_mouse_position() - position).normalized()
	anchor.rotation = dir.angle() + PI/2
	weaponAnchor.rotation_degrees = weaponRotDynamics.update(weaponDir * 120)
	sprite.scale = spriteScaleDynamics.update(Vector2.ONE)*0.9

	if Input.is_action_just_pressed("click"):
		weaponDir *= -1
		attack()

func takeDamage(damage):
	if isInvincible:
		return
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

	if (Input.is_action_just_pressed("dash") && dashing == false):
		start_dash()

	if (dashing == true):
		if (dashTime == 0):
			velocity *= dashSpeed
		dashTime += 1
	if (dashTime == 40):
		dashTime = 0
		dashing = false
		isInvincible = false

	if (dashing == true && dashTime <= 15):
		$SpriteContainer/Sprite.self_modulate.a = 0.5
	else:
		$SpriteContainer/Sprite.self_modulate.a = 1

	if velocity.length() < 3:
		$playerAnimations.play("idle")
	else:
		$playerAnimations.play("walking")
	if !lookingRight:
		$SpriteContainer.scale.x = -1
	else:
		$SpriteContainer.scale.x = 1


	move_and_slide()

func start_dash():
	dashing = true
	isInvincible = true
	spriteScaleDynamics.set_value(Vector2(1.5, 0.5))

func attack():
	var collisions = hitArea.get_overlapping_bodies()
	for body in collisions:
		if not body is Enemy: continue
		var dist = body.position.distance_to(weaponSprite.global_position)

		await Clock.wait(dist / 2000.0)

		Clock.hitstop(0.07)
		# RoomManager.current_room.camera.shake(0.5, 5)
		RoomManager.current_room.camera.jerk_direction(position - get_global_mouse_position(), 5.0)
		RoomManager.current_room.camera.tilt_impact()
		body.knockback((body.position - global_position).normalized() * 200)
		body.take_damage(1)

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area is XP:
		xp+=1
		if xp>maxXp:
			xp=xp%maxXp
		area.queue_free()
