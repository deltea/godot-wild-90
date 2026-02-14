extends Enemy

var state = "idle"

var agroRange = 200
var attackRange = 60

var speed = 20
var mood = 0

var idlePosition = Vector2.ZERO

func _ready() -> void:
	super._ready()
	mood = randi_range(-10,10)
	speed += randi_range(-10,10)

func _physics_process(delta: float) -> void:
	var playerPos = RoomManager.current_room.get_node("Player").position
	if state == "agro":
		var distanceToPlayer =  playerPos.distance_to(position)


		if distanceToPlayer > attackRange:
			#get closer
			linear_velocity = (playerPos-position).normalized() * speed
	elif state == "recover":
		linear_velocity = -(playerPos-position).normalized() * speed


func knockback(force):
	super.knockback(force)
	state = "recover"


func attack():
	state = "attackActive"
	var playerPos = RoomManager.current_room.get_node("Player").position
	linear_velocity += (playerPos-position).normalized() * speed * 10
	$attackTimer.start()

func stateUpdate() -> void:
	var moodSwing = randi_range(0,100+mood)
	var playerPos = RoomManager.current_room.get_node("Player").position
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
