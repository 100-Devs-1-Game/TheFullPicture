extends Node



func _ready() -> void:
	process_mode= Node.PROCESS_MODE_ALWAYS


func freeze_for(secs: float):
	get_tree().paused= true
	await get_tree().create_timer(secs).timeout
	get_tree().paused= false
