class_name UpgradePanel extends CanvasLayer

const upgrade_card_scene: PackedScene = preload("res://scenes/ui/upgrade-card/upgrade_card.tscn")
const ui_shadow_scene: PackedScene = preload("res://scenes/ui/shadow/ui_shadow.tscn")

@onready var container: HBoxContainer = $Panel/CenterContainer/UpgradeCardContainer
@onready var panel: Panel = $Panel

func _enter_tree() -> void:
	RoomManager.current_room.upgrade_panel = self

func _ready() -> void:
	create_cards()

func create_cards():
	for i in range(3):
		var card = upgrade_card_scene.instantiate() as UpgradeCard
		card.offset = i
		card.attribute = randi_range(0, 3)

		var rand = randf()
		if rand < 0.2:
			card.magnitude = 3
		elif rand < 0.4:
			card.magnitude = 2
		else:
			card.magnitude = 1

		container.add_child(card)

		# wait for the positions to be updated
		await get_tree().process_frame

		# add the shadow
		var shadow = ui_shadow_scene.instantiate() as TextureRect
		shadow.position = card.position + Vector2(12, 170)
		panel.add_child(shadow)

		card.shadow = shadow

func upgrade():
	# delete all previous cards
	for card in container.get_children():
		card.queue_free()

	create_cards()
	get_tree().paused = true
	visible = true

func finish_upgrade():
	get_tree().paused = false
	visible = false
