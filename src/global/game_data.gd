extends Node

@export var stages: Array[StageData]
var clues: Dictionary[String, ClueData]

var current_stage: StageData
var saved_checkboxes: Array[int]



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
		GameData.saved_checkboxes.clear()
		EventManager.entered_next_stage.emit()


func reset():
	for stage in stages:
		stage.completed= false
		current_stage= stages[0]

	for clue: ClueData in clues.values():
		clue.discovered= false

	saved_checkboxes.clear()


func save_checkboxes():
	saved_checkboxes.clear()
	for i in SceneLoader.game_panel.checkbox_grid.get_child_count():
		var checkbox: CheckBox= SceneLoader.game_panel.checkbox_grid.get_child(i)
		if checkbox.button_pressed:
			saved_checkboxes.append(i)


func get_current_stage_index()-> int:
	return stages.find(current_stage)
