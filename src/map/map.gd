@tool
class_name Map
extends Node2D

@export var map_size: Vector2i= Vector2i(3840, 2160)
@export var image_size: Vector2i= Vector2i(1280, 1080)
@export var columns: int= 2
@export var stages: Array[ImageCollection]

@export_tool_button("Init Canvas") var init_canvas_action = init_canvas

@onready var canvas: Node2D = $Canvas



func _ready() -> void:
	init_canvas()


func init_canvas(stage_idx: int= 0):
	var stage: ImageCollection= stages[stage_idx]
	
	var overwrite: bool= canvas.get_child_count(true) > 0
	if overwrite:
		print("Found existing sprites, overwriting..")
	var pos: Vector2i
	for i in stage.images.size():
		var image:= stage.images[i]
		var sprite: Sprite2D
		
		if overwrite:
			sprite= canvas.get_child(i, true)
		else:
			sprite= Sprite2D.new()
			canvas.add_child(sprite)
		
		sprite.position= pos + image_size / 2
		sprite.texture= image
		
		pos.x+= image_size.x
		@warning_ignore("integer_division")
		if pos.x / image_size.x == columns:
			pos.y+= image_size.y
			pos.x= 0
			
