class_name UpgradePanel extends CanvasLayer

const upgrade_card_scene: PackedScene = preload("res://scenes/ui/upgrade-card/upgrade_card.tscn")

@onready var container: HBoxContainer = $PanelContainer/CenterContainer/UpgradeCardContainer

func _ready() -> void:
	for i in range(3):
		var card = upgrade_card_scene.instantiate() as UpgradeCard
		card.offset = i
		container.add_child(card)
