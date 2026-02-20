extends Node2D

var mountain

@export var enemy = preload("res://scenes/enemies/mountainLion/mountainLion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mountain = get_parent().get_node("Mountain")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_cd_timeout() -> void:
	mountain.spawnEnemy(enemy)
	
