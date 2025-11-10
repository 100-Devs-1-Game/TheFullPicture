class_name InteractableObject
extends StaticBody2D

@export var data: InteractableObjectData
@export var unlock_stage: int= 0


func _ready() -> void:
	assert(data, str(name, " doesn't have a clue"))
	
