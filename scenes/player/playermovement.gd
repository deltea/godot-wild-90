class_name Player extends CharacterBody2D

@export var walkSpeed = 20
@export var heavySpeed = 4
@export var dashSpeed = 2

var speed = 20
var lookingRight = true
var dashTime = 0
var dashing = false
var weaponDir = 1
var health = 100
var maxHealth = 100
var isInvincible = false
var xp = 0
var maxXp = 100
var lvl = 0
var attackCD = false
var attackCDtime = 0.2
var attacking = false
var secondhit = false
var regenAmt = 0.005

@onready var anchor := $Anchor
@onready var weaponAnchor := $Anchor/WeaponAnchor
@onready var hitArea := $Anchor/HitArea
@onready var weaponSprite := $Anchor/WeaponAnchor/Sprite2D
@onready var particles := $MoveParticles
@onready var hpBar := $CanvasLayer/hpBar
@onready var collider := $CollisionShape2D
@onready var sprite := $SpriteContainer/Sprite
@onready var xpBar := $CanvasLayer/Panel/xpBar
@onready var levelNum := $CanvasLayer/Panel/xpBar/levelLabel/num

@onready var weaponRotDynamics: DynamicsSolver = Dynamics.create_dynamics(8.0, 0.8, 2.0)
@onready var spriteScaleDynamics: DynamicsSolverVector = Dynamics.create_dynamics_vector(2.0, 0.5, 2.0)

func _enter_tree() -> void:
	RoomManager.current_room.player = self


func levelUp(attribute,magnitude):
	#attribute value key:
	#0 = health
	#1 = speed
	#2 = dashSpeed
	#3 = attackCooldown
	#4 = healthRegen
	#5 = regenAmt
	magnitude*=.5
	match attribute:
		0:
			maxHealth += 10*magnitude
			hpBar.max_value = maxHealth
		1:
			speed += 3*magnitude
			walkSpeed = speed
			dashSpeed *= pow(0.95 , magnitude)
		2:
			dashSpeed += 0.6 * magnitude
		3:
			attackCDtime *= pow(0.95,magnitude)
			$attack.wait_time = attackCDtime
		4:
			regenAmt+=0.002*magnitude
		5:
			heavySpeed+=0.5*magnitude
			
			

func _ready() -> void:
	speed = walkSpeed
	hpBar.value = maxHealth
	xpBar.value = 0

var weaponPullback = 0
var winding = false
var windUp = 0
func _process(dt: float) -> void:

	var dir = (get_global_mouse_position() - position).normalized()
	anchor.rotation = dir.angle() + PI/2
	weaponAnchor.rotation_degrees = weaponRotDynamics.update(weaponDir * 120 + weaponPullback)
	sprite.scale = spriteScaleDynamics.update(Vector2.ONE)*0.9
	if winding:
		weaponPullback = (3.0-$heavy.time_left)*20*weaponDir
	if Input.is_action_just_pressed("click") and !attackCD:
		speed = heavySpeed
		winding = true
		$heavy.start()
	if Input.is_action_just_released("click") and !attackCD:
		speed = walkSpeed
		winding = false
		weaponPullback = 0
		windUp = (3.0-$heavy.time_left)
		var dirAngle = (atan2(get_global_mouse_position().y-position.y,get_global_mouse_position().x-position.x))
		var dirVector = Vector2(cos(dirAngle),sin(dirAngle))

		weaponRotDynamics = Dynamics.create_dynamics(8.0-windUp*1.5, 0.8, 2.0)

		velocity += dirVector*windUp*400
		weaponDir *= -1

		$attack.start()
		$swing.start()
		$Anchor/HitArea.visible=true
		attacking = true
		attackCD = true

		attack(int(1+windUp))

func takeDamage(damage):
	if isInvincible:
		return
	health -= damage
	hpBar.value = health
	if health <= 0:
		die()
	else:
		AudioManager.play_sound(AudioManager.hurt, 0.2)
var input = Vector2.ZERO
func die():
	$"../AudioStreamPlayer".stop()
	AudioManager.play_sound(AudioManager.death, 0.2)
	RoomManager.current_room.death_panel.death()

func _physics_process(delta: float) -> void:
	if velocity.length() > 1500:
		velocity = velocity.normalized()
	health+=regenAmt
	hpBar.value=health
	# simple movement
	input = Input.get_vector("left", "right", "up", "down")
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
	AudioManager.play_sound(AudioManager.dash, 0.2)
	dashing = true
	isInvincible = true
	spriteScaleDynamics.set_value(Vector2(1.5, 0.5))

func attack(damage):
	var hitEnemy=false
	var collisions = hitArea.get_overlapping_bodies()
	if !secondhit:
		AudioManager.play_sound(AudioManager.attack, 0.2)

	for body in collisions:
		if not body is Enemy:continue
		var dist = body.position.distance_to(weaponSprite.global_position)

		await Clock.wait(dist / 2000.0)

		Clock.hitstop(0.07)
		# RoomManager.current_room.camera.shake(0.5, 5)
		RoomManager.current_room.camera.jerk_direction(position - get_global_mouse_position(), 5.0)
		RoomManager.current_room.camera.tilt_impact()
		body.knockback((body.position - global_position).normalized() * 200)
		body.take_damage(damage)
		hitEnemy=true
	if !hitEnemy:
		secondhit=true

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area is Projectile and !dashing:
		takeDamage(20)
		area.blowUp()
	if area is XP:
		AudioManager.play_sound(AudioManager.xp, 0.2)
		xp+=10
		if xp>maxXp:
			maxXp+=10
			xp=xp%maxXp
			lvl += 1
			levelNum.text = str(lvl)
			RoomManager.current_room.upgrade_panel.upgrade()

		area.queue_free()
		xpBar.value = xp/(maxXp*1.0)*100


func _on_attack_timeout() -> void:
	attackCD = false

func _on_swing_timeout() -> void:
	attacking=false
	if secondhit:
		attack(1+windUp)
		secondhit=false
	$Anchor/HitArea.visible=false
