extends Node2D

@export var elevationBar: ProgressBar

var player

# in degrees
var theta = 0
var elevation = 0.0
var scaleMod = 1.0
var kRad = 340

var maxElevation = 1000
var fullRotations = 0
var maxRotations = 10

var folliage = preload("res://scenes/folliage/folliage.tscn")
var folliageList = []
var recordTheta = 0

func _ready() -> void:
	player = RoomManager.current_room.player

	#spawn initial folliage
	for i in range(60):
		spawnFolliage(10,i*6)

func spawnFolliage(num, angle):
	for i in range(num):
		var r = 360
		var oppositeAngle = deg_to_rad(-(angle))
		var color = Color.DARK_SEA_GREEN
		var newPlant = folliage.instantiate()

		get_parent().get_node("folliageContainer").add_child(newPlant)

		#randomize
		r += randf_range(-80,100)
		oppositeAngle += randf_range(-0.15,0.15)
		newPlant.frame = randi_range(0,1)
		color.r += randf_range(-0.2,0.2)

		r*=scaleMod
		newPlant.modulate = color
		if randi_range(0,1) == 1:
			newPlant.flip_h = true

		#set folliage position
		newPlant.global_position.x = cos(oppositeAngle)*r
		newPlant.global_position.y = sin(oppositeAngle)*r

		#old folliage culling
		if len(folliageList) > 100:
			for plant in folliageList:
				if is_instance_valid(plant):
					if plant.position.distance_to(position) > scale.length()*kRad:
						plant.queue_free()
		newPlant.z_index = -9
		folliageList.append(newPlant)

func environmentalUpdate():
	print("hi")
	for env in $"../environmentContainer".get_children():
		var dy = env.position.y-position.y
		var dx = env.position.x-position.x
		var angle = int(rad_to_deg(-atan2(dy, dx))+180)
		var difference = abs(angle-theta)
		if difference >= 180:
			difference = abs(difference-360)
		if difference > 150:
			env.updateSprite(false)

func _process(delta: float) -> void:
	#print(theta)
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y

	var lastTheta = theta



	theta = int(rad_to_deg(-atan2(dy, dx)) + 180)




	if theta < 10 and (lastTheta > 180):
		fullRotations += 1
	if theta > 350 and lastTheta < 180:
		fullRotations -= 1

	elevation = theta + (360 * fullRotations)
	var adjustedElevation = (elevation / (360.0 * maxRotations)) * 100.0
	elevationBar.value = adjustedElevation

	scaleMod = 	(2.0-(adjustedElevation/100.0))/2
	scale = Vector2.ONE * scaleMod


func folliageCheck() -> void:
	if abs(recordTheta-theta)>3:
		spawnFolliage(10,theta)
		environmentalUpdate()
	recordTheta=theta

func spawnEnemy(scene):
	var enemy = scene.instantiate()
	RoomManager.current_room.add_child(enemy)
	var r = 360
	var oppositeAngle = deg_to_rad(-(theta))

	#randomize
	r += randf_range(-80,100)
	oppositeAngle += randf_range(-0.15,0.15)

	r*=scaleMod

	#set folliage position
	enemy.global_position.x = cos(oppositeAngle)*r
	enemy.global_position.y = sin(oppositeAngle)*r
