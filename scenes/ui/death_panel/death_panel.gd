class_name DeathPanel extends CanvasLayer

func _enter_tree() -> void:
	RoomManager.current_room.death_panel = self

func death():
	get_tree().paused = true
	visible = true

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		# get_tree().reload_current_scene()
		RoomManager.restart_room()

func _on_button_2_gui_input(event: InputEvent) -> void:
	pass
	# if event is InputEventMouseButton and event.pressed:
		# RoomManager.change_room(
