extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func updateSprite(snow):
	if !snow:
		$sprite.frame = randi_range(1,5)
