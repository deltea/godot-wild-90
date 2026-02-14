class_name Level extends Room

var is_droning = false
var drone: Drone

func toggle_drone():
	is_droning = !is_droning
	player.can_move = !is_droning
	drone.can_move = is_droning

func _ready() -> void:
	toggle_drone()
