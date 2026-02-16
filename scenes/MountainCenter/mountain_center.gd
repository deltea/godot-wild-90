extends Node2D

@export var elevationBar: ProgressBar

var player

# in degrees
var theta = 0
var elevation = 0.0
var maxElevation = 1000
var fullRotations = 0
var maxRotations = 10

var folliage = preload("res://scenes/folliage/folliage.tscn")

func _ready() -> void:
	player = RoomManager.current_room.player

func spawnFolliage(num):
	print("plant")
	for i in range(num):
		var oppositeAngle = deg_to_rad(-(theta+180))
		var newPlant = folliage.instantiate()
		add_child(newPlant)
		var r = 380
		
		#randomize
		r += randf_range(-80,80)
		oppositeAngle += randf_range(-0.15,0.15)
		newPlant.frame = randi_range(0,1)
		if randi_range(0,1) == 1:
			newPlant.flip_H = true

		newPlant.global_position.x = cos(oppositeAngle)*r
		newPlant.global_position.y = sin(oppositeAngle)*r

func _process(delta: float) -> void:
	#print(theta)
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y

	var lastTheta = theta
	
	if Input.is_action_just_pressed("dash"):
		spawnFolliage(20)

	theta = int(rad_to_deg(-atan2(dy, dx)) + 180)

	if theta < 10 and (lastTheta > 180):
		fullRotations += 1
	if theta > 350 and lastTheta < 180:
		fullRotations -= 1

	elevation = theta + (360 * fullRotations)
	var adjustedElevation = (elevation / (360.0 * maxRotations)) * 100.0
	elevationBar.value = adjustedElevation

	scale = Vector2.ONE * ((100.0 - adjustedElevation) / 100.0)
