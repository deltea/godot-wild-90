extends StaticBody2D

var startVector
var startDist
var mountain
func _ready() -> void:
	mountain = get_parent().get_parent().get_node("Mountain")
	startDist = position.distance_to(mountain.position)
	startVector = (position-mountain.position).normalized()
	position = Vector2.ZERO
	
func _process(delta: float) -> void:
	position = startVector*startDist*mountain.scaleMod
	
func updateSprite(snow):
	if !snow:
		$sprite.frame = randi_range(0,4)
