class_name StageData
extends Resource

@export var clues: Array[ClueData]
@export var sentence_builder_scene: PackedScene

var completed:= false


func init():
	for clue in clues:
		GameData.clues[clue.word.to_lower()]= clue
