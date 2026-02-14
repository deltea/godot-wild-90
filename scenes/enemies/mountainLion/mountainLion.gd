extends Enemy

var state = "idle"

func _physics_process(delta: float) -> void:
	if state == "attack":
		RoomManager.current_room.get_node("Player").position
