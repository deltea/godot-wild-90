extends CharacterBody2D
var lookingRight = true
@export var speed = 10
@export var dashTime = 20
var dashing = false
var dashSpeed = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var InputDir = Input.get_vector("left","right", "up", "down")
	velocity += InputDir * speed
	if(dashTime > 7 || dashing == false):
		velocity*=0.9
	if Input.is_action_just_pressed("right"):
		lookingRight = true
	if Input.is_action_just_pressed("left"):
		lookingRight = false
		
	
	if(Input.is_action_just_pressed("dash") && dashing == false):
		$dashSFX.play()
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
