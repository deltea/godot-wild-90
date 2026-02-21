extends Enemy

var state = "idle"
var agroMove = "straight"

var agroRange = 200
var attackRange = 60

var speed = 200
var mood = 0

var idlePosition = Vector2.ZERO

func _ready() -> void:
	super._ready()
	mood = randi_range(-10,10)
	speed += randi_range(-10,10)
var moodSwing
func _physics_process(delta: float) -> void:
	rotation = 0
	var playerPos = RoomManager.current_room.get_node("Player").position
	if state == "agro":
		var distanceToPlayer =  playerPos.distance_to(position)


		if distanceToPlayer > attackRange:
			var playerVector = (playerPos-position).normalized()
			if agroMove == "straight":
				#get closer
				# linear_velocity = (playerPos-position).normalized() * speed
				apply_central_force(playerVector * speed * mass)
			elif agroMove == "strafe":
				var dir = Vector2(-playerVector.y,playerVector.x)
				if moodSwing< 50:
					apply_central_force(dir * speed * mass * 0.8)
				else:
					apply_central_force(-dir * speed * mass * 0.8)
	elif state == "recover":
		# linear_velocity = -(playerPos-position).normalized() * speed
		apply_central_force(-(playerPos-position).normalized() * speed * mass)


func knockback(force):
	super.knockback(force)
	state = "recover"


func attack():
	state = "attackActive"
	var playerPos = RoomManager.current_room.player.position
	# linear_velocity += (playerPos-position).normalized() * speed * 10
	apply_central_impulse((playerPos-position).normalized() * 200 * mass)
	$attackTimer.start()

func stateUpdate() -> void:
	moodSwing = randi_range(0,100+mood)
	var playerPos = RoomManager.current_room.player.position
	if state == "agro":
		if moodSwing < 30:
			agroMove = "strafe"
			linear_velocity = Vector2.ZERO
		else:
			agroMove = "straight"

	if state == "attackInactive":
		if moodSwing < 50:
			attack()
	elif state == "recovery":
		if moodSwing < 50:
			state == "idle"
	elif position.distance_to(playerPos) < agroRange:
		if position.distance_to(playerPos) > attackRange:
			if moodSwing < 80:
				state = "agro"
		else:
			if state == "agro":
				#just entered attack
				linear_velocity = Vector2.ZERO
			state = "attackInactive"
	else:
		if moodSwing < 80:
			state = "idle"




func attackOver() -> void:
	linear_velocity = Vector2.ZERO
	state="recover"

func _on_body_entered(body: Node) -> void:
	if body is Player and state == "attackActive":
		body.takeDamage(damage)
		knockback((position - body.position).normalized() * 200)
