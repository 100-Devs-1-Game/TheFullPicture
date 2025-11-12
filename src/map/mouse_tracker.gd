extends Node2D




var point_query:= PhysicsPointQueryParameters2D.new()
var hovering_over: InteractableObject:
	set(obj):
		assert(obj == null or obj is InteractableObject)
		if hovering_over == obj:
			return
		var prev:= hovering_over
		hovering_over= obj
		if prev == null:
			enter_object()
		else:
			exit_object()
			if hovering_over:
				enter_object()


func _physics_process(_delta: float) -> void:
	point_query.position= get_global_mouse_position()
	var result:= get_world_2d().direct_space_state.intersect_point(point_query)
	hovering_over= result[0].collider if result else null
	

func enter_object():
	prints("Enter object", hovering_over.name)
	EventManager.mouse_hover.emit()


func exit_object():
	print("Exit object")
	EventManager.mouse_unhover.emit()
