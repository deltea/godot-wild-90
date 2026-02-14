extends Node2D

var player

#in degrees
var theta = 0
var elevation = 0
var maxElevation = 1000
var fullRotations = 0


func _ready() -> void:
	player = get_parent().get_node("player")


func _process(delta: float) -> void:
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y
	
	var lastTheta = theta
	
	theta = int(rad_to_deg(-atan2(dy,dx))+180)

	if theta<10 and (lastTheta > 180):
		fullRotations+=1
	if theta>350 and lastTheta < 180:
		fullRotations-=1
		
	elevation = theta+(360*fullRotations)
	
