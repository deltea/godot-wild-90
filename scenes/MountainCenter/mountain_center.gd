extends Node2D

var player

#in degrees
var theta = 0

func _ready() -> void:
	player = get_parent().get_node("player")


func _process(delta: float) -> void:
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y
	theta = rad_to_deg(-atan2(dy,dx))+180
	print(theta)
