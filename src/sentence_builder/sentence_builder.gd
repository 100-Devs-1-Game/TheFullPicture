class_name SentenceBuilder
extends Control

@onready var solution: Control = %Solution

var solution_items: Array[Label]


func _ready() -> void:
	for child in solution.get_children():
		solution_items.append(child)
