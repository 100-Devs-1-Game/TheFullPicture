class_name StageData
extends Resource

@export var clues: Array[ClueData]
@export var solved_painting: Texture2D
@export var solution: SolutionData 

var completed:= false



func init():
	for clue in clues:
		GameData.clues[clue.word.to_lower()]= clue
