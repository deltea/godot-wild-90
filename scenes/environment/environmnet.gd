extends StaticBody2D

var startVector
var startDist
var mountain
func _ready() -> void:
	mountain = get_parent().get_parent().get_node("Mountain")
	startDist = position.distance_to(mountain.position)
	startVector = abs(position-mountain.position)
	
func _process(delta: float) -> void:
	pass
	
func updateSprite(snow):
	if !snow:
		$sprite.frame = randi_range(1,5)
