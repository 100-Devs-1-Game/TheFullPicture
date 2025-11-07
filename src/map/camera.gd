extends Camera2D

@onready var map: Map= get_parent()


func _ready() -> void:
	await map.ready
	position= map.map_size / 2
