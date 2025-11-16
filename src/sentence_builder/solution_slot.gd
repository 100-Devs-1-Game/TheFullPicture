class_name SolutionSlot
extends Label

var clue_button: ClueButton



func fill(button: ClueButton):
	clue_button= button
	text= clue_button.label.text
