class_name InteractableObject
extends StaticBody2D

@export var clues: InteractableObjectData
@export var unlock_stage: int= 0


func _ready() -> void:
	assert(clues, str(name, " doesn't have a clue"))
	
