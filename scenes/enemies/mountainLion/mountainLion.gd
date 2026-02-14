extends Enemy

var state = "idle"
var agroRange = 200
var speed = 20

func _physics_process(delta: float) -> void:
	if state == "attack":
		var playerPos = RoomManager.current_room.get_node("Player").position
		linear_velocity = (playerPos-position).normalized() * speed
		


func stateUpdate() -> void:
	var moodSwing = randi_range(0,100)
	var playerPos = RoomManager.current_room.get_node("Player").position
	if position.distance_to(playerPos) < agroRange:
		if moodSwing < 50:
			state = "attack"
	else:
		if moodSwing < 80:
			state = "idle"
		
