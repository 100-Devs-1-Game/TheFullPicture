class_name InteractableObjectData
extends Resource

@export var name: String
@export_file("*.txt") var clues_file: String:
	set(f):
		clues_file= f
		description= FileAccess.get_file_as_string(f)
		

## Interactable Objects can contain multiple objects, like a
## Desk can contain a Pen. The Pen is only reachable via the Desk
@export var container: Array[InteractableObjectData]

var description: String
