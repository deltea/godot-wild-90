class_name UpgradePanel extends CanvasLayer

const upgrade_card_scene: PackedScene = preload("res://scenes/ui/upgrade-card/upgrade_card.tscn")
const ui_shadow_scene: PackedScene = preload("res://scenes/ui/shadow/ui_shadow.tscn")

@onready var container: HBoxContainer = $Panel/CenterContainer/UpgradeCardContainer
@onready var panel: Panel = $Panel

func _ready() -> void:
	for i in range(3):
		var card = upgrade_card_scene.instantiate() as UpgradeCard
		card.offset = i
		container.add_child(card)

		# wait for the positions to be updated
		await get_tree().process_frame

		# add the shadow
		var shadow = ui_shadow_scene.instantiate() as TextureRect
		shadow.position = card.position + Vector2(12, 170)
		panel.add_child(shadow)

		card.shadow = shadow
