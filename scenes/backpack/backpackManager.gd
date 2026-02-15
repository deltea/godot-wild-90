extends Node2D

var backpackSpace = []
var backpackCells = []
var rows = 5
var columns = 4

var bpCell = preload("res://scenes/backpack/backpack_cell.tscn")
var cellWidth = 21

var square = [[1,1],[1,1]]


func _ready() -> void:
	var row = [0, 0, 0, 0]
	for i in range(rows):
		backpackSpace.append(row)
		
	#place cells
	for r in range(rows):
		var newRow = []
		for c in range(columns):
			var cell = bpCell.instantiate()
			$CanvasLayer.add_child(cell)
			cell.position = Vector2(c*cellWidth,r*cellWidth)
			newRow.append(cell)
		backpackCells.append(newRow)
			
func _process(delta: float) -> void:
	var mousePos = get_global_mouse_position()
	for r in backpackCells:
		for cell in r:
			var cellPos = Vector2(cell.position.x + cellWidth/2, cell.position.y + cellWidth/2)
			if cellPos.distance_to(mousePos) < 10:
				cell.color = Color.RED
	
