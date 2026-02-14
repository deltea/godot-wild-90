extends CharacterBody2D

var lookingRight = true
@export var speed = 10
var dashTime = 0
var dashing = false
@export var dashSpeed = 2


	
func _physics_process(delta: float) -> void:
	#simple movement
	var InputDir = Input.get_vector("left","right", "up", "down")
	velocity += InputDir * speed
	
	#when dashing
	if(dashTime > 7 || dashing == false):
		velocity*=0.9
	if Input.is_action_just_pressed("right"):
		lookingRight = true
	if Input.is_action_just_pressed("left"):
		lookingRight = false
		
	
	if(Input.is_action_just_pressed("dash") && dashing == false):
		dashing = true
	
	if(dashing == true):
		if(dashTime == 0):
			velocity*=dashSpeed
		dashTime+=1
	if(dashTime == 40):
		dashTime = 0
		dashing = false
		
	if(dashing == true && dashTime <= 15):
		$Sprite.self_modulate.a = 0.5
	else:
		$Sprite.self_modulate.a = 1
		
	move_and_slide()
