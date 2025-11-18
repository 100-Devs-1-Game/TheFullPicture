class_name SentenceBuilder
extends Control

@export var clue_button_scene: PackedScene

@onready var clues: GridContainer = %Clues
@onready var solution: Control = %Solution
@onready var solved_painting: TextureRect = $SolvedPainting
@onready var popup_panel: Panel = %"Popup Panel"

var solution_items: Array[Label]
var dragging_button: ClueButton
var drag_texture: TextureRect
var dragging_offset: Vector2
var hover_slot: SolutionSlot
var filled_counter:= 0



func _ready() -> void:
	for slot: SolutionSlot in solution.get_children():
		slot.mouse_entered.connect(on_hover_slot.bind(slot))
		slot.mouse_exited.connect(func(): hover_slot= null)
		slot.remove_clue.connect(func(button: ClueButton): button.return_button())
		slot.text= ""
		solution_items.append(slot)

	for child in clues.get_children():
		clues.remove_child(child)
		child.queue_free()
	
	var grid_pos: Vector2i
	for clue in GameData.current_stage.clues:
		@warning_ignore("integer_division")
		while (grid_pos.x + grid_pos.y) % 2 > 0:
			clues.add_child(Control.new())
			grid_pos= advance_grid_pos(grid_pos)
			
		var button: ClueButton= clue_button_scene.instantiate()
		clues.add_child(button)
		button.set_clue(clue)
		button.start_dragging.connect(on_start_dragging)
		grid_pos= advance_grid_pos(grid_pos)


func _process(_delta: float) -> void:
	if dragging_button:
		if Input.is_action_just_released("drag"):
			if hover_slot:
				hover_slot.fill(dragging_button)
				filled_counter+= 1
				if filled_counter == GameData.current_stage.solution.clues.size():
					verify_solution()
			else:
				dragging_button.return_button()
			drag_texture.queue_free()
			dragging_button= null
		else:
			drag_texture.position= get_global_mouse_position() + dragging_offset


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F1:
			if OS.is_debug_build():
				solved()


func advance_grid_pos(grid_pos: Vector2i)-> Vector2i:
	grid_pos.x+= 1
	if grid_pos.x > 1:
		grid_pos.y+= 1
		grid_pos.x= 0
	return grid_pos


func verify_solution():
	var i= 0
	var correct:= true
	for slot: SolutionSlot in solution.get_children():
		if not slot.clue_button:
			continue
		if GameData.current_stage.solution.clues[i] !=\
			slot.clue_button.data:
				correct= false
				break
		i+= 1

	if correct:
		solved()
	else:
		popup_panel.show()


func solved():
	solved_painting.texture= GameData.current_stage.solved_painting
	GameData.advance_stage()
	
	#SceneLoader.goto_map()


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


func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()
