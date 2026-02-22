class_name Room extends Node2D

@export var palette: Texture2D

var camera: Camera
var upgrade_panel: UpgradePanel
var death_panel: DeathPanel

func _enter_tree() -> void:
	RoomManager.current_room = self
