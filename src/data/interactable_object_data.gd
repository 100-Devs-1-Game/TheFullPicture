class_name InteractableObjectData
extends Resource

@export var name: String
@export_multiline var description: String

## Interactable Objects can contain multiple objects, like a
## Desk can contain a Pen. The Pen is only reachable via the Desk
@export var container: Array[InteractableObjectData]
