extends Node2D

var backpackSpace = []
var rows = 5
var columns = 4

var bpCell = preload("res://scenes/backpack/backpack_cell.tscn")
var cellWidth = 30

var square = [[1,1],[1,1]]


func _ready() -> void:
	var row = [0, 0, 0, 0]
	for i in range(rows):
		backpackSpace.append(row)
		
	#place cells
	for r in range(rows):
		for c in range(columns):
			pass
	
