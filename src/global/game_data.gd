extends Node

@export var stages: Array[StageData]
@export var clues: Dictionary[String, ClueData]

var current_stage: StageData


func _ready() -> void:
	for stage in stages:
		stage.init()
		if not current_stage and not stage.finished:
			current_stage= stage
