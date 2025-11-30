class_name StageData
extends Resource

@export var clues: Array[ClueData]
@export var solved_painting: Texture2D
@export var solution_container: SolutionContainer
@export var pre_placed_clues: Dictionary[int, String]

@export_multiline var correct_dialog: String
@export_multiline var fail_dialog: String
@export_multiline var incorrect_dialog: String
@export_multiline var special_dialog: String

var completed:= false



func init():
	for clue in clues:
		GameData.clues[clue.word.to_lower()]= clue
