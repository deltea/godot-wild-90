extends Enemy

var state = "idle"

var agroRange = 200
var attackRange = 60

var speed = 20

var idlePosition = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if state == "attack":
		var playerPos = RoomManager.current_room.get_node("Player").position
		var distanceToPlayer =  playerPos.distance_to(position)
		
		#get closer
		if distanceToPlayer > attackRange:
			linear_velocity = (playerPos-position).normalized() * speed
		else:
			linear_velocity = Vector2.ZERO

func knockback(force):
	super.knockback(force)
	state = "recover"


func stateUpdate() -> void:
	var moodSwing = randi_range(0,100)
	var playerPos = RoomManager.current_room.get_node("Player").position
	if position.distance_to(playerPos) < agroRange:
		if moodSwing < 80:
			state = "attack"
	else:
		if moodSwing < 80:
			state = "idle"
		
