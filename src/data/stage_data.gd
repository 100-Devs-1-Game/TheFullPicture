class_name StageData
extends Resource

@export var clues: Array[ClueData]

var finished:= false


func init():
	for clue in clues:
		GameData.clues[clue.word.to_lower()]= clue
