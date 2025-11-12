# src/map/camera.gd
extends Camera2D

@export var pan_speed: float = 500.0
@export var edge_pan_margin: int = 20
@export var edge_pan_speed: float = 600.0

const ZOOM_DEFAULT := 1.0
const ZOOM_IN_2X   := 2.0
const ZOOM_IN_3X   := 3.0

var _map: Node2D = null
var _zoom_factors: Array[float] = []
var _zoom_level: int = 1

func _ready() -> void:
	_map = _find_map_node(get_tree().root)
	if not _map:
		push_error("Camera could not find a node with 'map_size' in the scene!")
		return

	var map_size: Vector2 = _map.map_size
	var viewport_size: Vector2 = get_viewport_rect().size

	var fit_zoom_x = viewport_size.x / map_size.x
	var fit_zoom_y = viewport_size.y / map_size.y
	var fit_zoom = min(fit_zoom_x, fit_zoom_y)

	_zoom_factors = [fit_zoom, ZOOM_DEFAULT, ZOOM_IN_2X, ZOOM_IN_3X]

	global_position = _map.map_size * 0.5
	_set_zoom_level(1)

	set_process_input(true)
	set_process(true)

func _process(delta: float) -> void:
	if not _map: return
	if _zoom_level == 0: return

	var pan_input := Vector2.ZERO

	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		pan_input.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		pan_input.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		pan_input.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		pan_input.y -= 1

	if pan_input != Vector2.ZERO:
		pan_input = pan_input.normalized()
		_move_camera(pan_input * pan_speed * delta)

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var vp_rect: Rect2 = get_viewport_rect()
	var edge_dir := Vector2.ZERO

	if mouse_pos.x < edge_pan_margin:
		edge_dir.x -= 1
	if mouse_pos.x > vp_rect.size.x - edge_pan_margin:
		edge_dir.x += 1
	if mouse_pos.y < edge_pan_margin:
		edge_dir.y -= 1
	if mouse_pos.y > vp_rect.size.y - edge_pan_margin:
		edge_dir.y += 1

	if edge_dir != Vector2.ZERO:
		edge_dir = edge_dir.normalized()
		_move_camera(edge_dir * edge_pan_speed * delta)

func _input(event: InputEvent) -> void:
	if not _map: return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_change_zoom_level(1)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_change_zoom_level(-1)
			get_viewport().set_input_as_handled()

func _move_camera(offset: Vector2) -> void:
	global_position += offset
	_clamp_to_map_bounds()

func _set_zoom_level(idx: int) -> void:
	if _zoom_factors.is_empty():
		return

	idx = clamp(idx, 0, _zoom_factors.size() - 1)
	_zoom_level = idx

	if idx == 0:
		global_position = _map.map_size * 0.5

	zoom = Vector2.ONE * _zoom_factors[idx]
	_clamp_to_map_bounds()

func _change_zoom_level(delta: int) -> void:
	_set_zoom_level(_zoom_level + delta)

func _clamp_to_map_bounds() -> void:
	if not _map: return

	var map_size: Vector2 = _map.map_size
	var half_map := map_size * 0.5

	var viewport_size: Vector2 = get_viewport_rect().size
	var visible_world := viewport_size / zoom
	var half_visible := visible_world * 0.5

	var min_pos := half_map - half_visible
	var max_pos := half_map + half_visible

	global_position.x = clamp(global_position.x, min_pos.x, max_pos.x)
	global_position.y = clamp(global_position.y, min_pos.y, max_pos.y)

func _find_map_node(node: Node) -> Node:
	if "map_size" in node or node.has_method("get_map_size"):
		return node

	for child in node.get_children():
		var found = _find_map_node(child)
		if found:
			return found

	return null
