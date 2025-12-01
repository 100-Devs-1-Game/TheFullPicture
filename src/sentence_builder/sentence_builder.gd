class_name SentenceBuilder
extends Control

@export var clue_button_scene: PackedScene

@onready var clues: GridContainer = %Clues
@onready var solution: Control = %Solution
@onready var solved_painting: TextureRect = $SolvedPainting
@onready var popup_panel: Panel = %"Popup Panel"
@onready var popup_label: RichTextLabel = %"Popup Label"

@onready var try_again_button: TextureButton = %"Try Again Button"
@onready var continue_button: TextureButton = %"Continue Button"

@onready var audio_player_fill_slot: AudioStreamPlayer = $"AudioStreamPlayer Fill Slot"
@onready var audio_player_return_clue: AudioStreamPlayer = $"AudioStreamPlayer Return Clue"
@onready var audio_player_correct: AudioStreamPlayer = $"AudioStreamPlayer Correct"
@onready var audio_player_incorrect: AudioStreamPlayer = $"AudioStreamPlayer Incorrect"


var solution_items: Array[Label]
var dragging_button: ClueButton
var drag_texture: TextureRect
var dragging_offset: Vector2
var hover_slot: SolutionSlot
var filled_counter:= 0



func _ready() -> void:
	var current_stage:= GameData.current_stage
	
	var stage_index:= GameData.get_current_stage_index() 
	if stage_index > 0:
		%Ribbon2.show()
	
	for slot: SolutionSlot in solution.get_children():
		if slot.stage > stage_index:
			solution.remove_child(slot)
			slot.queue_free()
	
	for i in solution.get_child_count():
		var slot: SolutionSlot= solution.get_child(i)
		
		if current_stage.pre_placed_clues.has(i):
			slot.text= current_stage.pre_placed_clues[i].to_upper()
		else:
			slot.mouse_entered.connect(on_hover_slot.bind(slot))
			slot.mouse_exited.connect(func(): hover_slot= null)
			slot.remove_clue.connect(on_remove_clue)
			slot.text= ""

		solution_items.append(slot)

	for child in clues.get_children():
		clues.remove_child(child)
		child.queue_free()
	
	var grid_pos: Vector2i
	var space:= false
	for clue in current_stage.clues:
		if space:
			clues.add_child(Control.new())
			grid_pos= advance_grid_pos(grid_pos)
			
		var button: ClueButton= clue_button_scene.instantiate()
		clues.add_child(button)
		button.set_clue(clue)
		button.start_dragging.connect(on_start_dragging)
		grid_pos= advance_grid_pos(grid_pos)
		space= true

	%Question.text= current_stage.question

	MusicPlayer.play_sentence()


func _process(_delta: float) -> void:
	if dragging_button:
		if Input.is_action_just_released("drag"):
			if hover_slot:
				hover_slot.fill(dragging_button)
				filled_counter+= 1
				assert(filled_counter <= solution.get_child_count())
				var solution_size:= solution.get_child_count() - GameData.current_stage.pre_placed_clues.size()
				if filled_counter == solution_size:
					verify_solution()
				else:
					audio_player_fill_slot.play()
			else:
				audio_player_return_clue.play()
				dragging_button.return_button()
			drag_texture.queue_free()
			dragging_button= null
		else:
			drag_texture.position= get_global_mouse_position() + dragging_offset


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not event.pressed:
			return

		if event.keycode == KEY_F1:
			if OS.is_debug_build():
				popup_label.text= GameData.current_stage.correct_dialog
				solved()
				popup_panel.show()


func advance_grid_pos(grid_pos: Vector2i)-> Vector2i:
	grid_pos.x+= 1
	if grid_pos.x > 1:
		grid_pos.y+= 1
		grid_pos.x= 0
	return grid_pos


func verify_solution():
	var container: SolutionContainer= GameData.current_stage.solution_container
	var i= 0
	var correct:= true
	var incorrect:= true
	var special:= false
	if container.special_solution:
		special= true
	
	for slot: SolutionSlot in solution.get_children():
		if not slot.clue_button:
			continue
		if container.correct_solution.clues[i] != slot.clue_button.data:
				correct= false
		
		var found_incorrect:= false
		for incorrect_solution in container.incorrect_solutions:
			if incorrect_solution.clues[i] == slot.clue_button.data:
				found_incorrect= true
				break
		
		if not found_incorrect:
			incorrect= false

		if special:
			if container.special_solution.clues[i] != slot.clue_button.data:
				special= false

		if not correct and not incorrect and not special:
			break
		
		i+= 1

	try_again_button.show()
	continue_button.hide()

	if correct:
		audio_player_correct.play()
		popup_label.text= GameData.current_stage.correct_dialog
		solved()
		await GameFreezer.freeze_for(4)
	else:
		audio_player_incorrect.play()
		
		if special:
			popup_label.text= GameData.current_stage.special_dialog
		elif incorrect:
			popup_label.text= GameData.current_stage.incorrect_dialog
		else:
			popup_label.text= GameData.current_stage.fail_dialog

	popup_panel.show()


func solved():
	solved_painting.texture= GameData.current_stage.solved_painting
	GameData.advance_stage()
	try_again_button.hide()
	continue_button.show()


func on_start_dragging(button: ClueButton):
	dragging_button= button
	drag_texture= button.duplicate(0)

	var button_label: Label= drag_texture.get_child(0)
	# Remove HoverComponent
	button_label.get_child(0).queue_free()
	button_label.mouse_filter= Control.MOUSE_FILTER_IGNORE
	
	drag_texture.z_index= 100
	drag_texture.mouse_filter= Control.MOUSE_FILTER_IGNORE
	drag_texture.focus_mode= Control.FOCUS_NONE
	dragging_offset= button.global_position - get_global_mouse_position()
	get_tree().root.add_child(drag_texture)
	EventManager.mouse_drag.emit()


func on_hover_slot(slot: SolutionSlot):
	hover_slot= slot


func on_remove_clue(button: ClueButton):
	button.return_button()
	filled_counter-= 1


func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene.call_deferred()


func _on_continue_button_pressed() -> void:
	if GameData.stages[-1].completed:
		GameData.reset()
		SceneLoader.goto_main_menu()
	else:
		
		SceneLoader.goto_map()
