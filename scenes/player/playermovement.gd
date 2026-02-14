extends CollisionShape2D
var lookingRight = true
@export var speed = 10
@export var DashTime = 20
var dashing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var InputDir = Input.get_vector("Left","Right", "Up", "Down")
	velocity += InputDir * speed
	if(DashTime > 7 || Dashing == false):
		velocity*=0.9
	if Input.is_action_just_pressed("Right"):
		lookingRight = true
	if Input.is_action_just_pressed("Left"):
		lookingRight = false
		
	
	if(Input.is_action_just_pressed("Dash") && Dashing == false):
		$dashSFX.play()
		Dashing = true
	
	if(Dashing == true):
		if(DashTime == 0):
			velocity*=DashSpeed
		DashTime+=1
	if(DashTime == 40):
		DashTime = 0
		Dashing = false
		
	if(Dashing == true && DashTime <= 15):
		$Sprite.self_modulate.a = 0.5
	else:
		$Sprite.self_modulate.a = 1
