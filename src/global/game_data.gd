extends Node

@export var stages: Array[StageData]
var clues: Dictionary[String, ClueData]

var current_stage: StageData


func _ready() -> void:
	for stage in stages:
		stage.init()
		if not current_stage and not stage.completed:
			current_stage= stage


func advance_stage():
	current_stage.completed= true
	var idx:= get_current_stage_index() + 1 
	if idx < stages.size():
		current_stage= stages[idx]
		EventManager.entered_next_stage.emit()


func get_current_stage_index()-> int:
	return stages.find(current_stage)
