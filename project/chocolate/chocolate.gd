class_name Chocolate
extends Node2D

signal drag_changed_sent

var _is_dragging := false
var _draggable := false
var _is_inside_dropable := false
var _current_object : StaticBody2D
var _hovered_object : StaticBody2D
var _offset : Vector2
var _initial_pos : Vector2

func _ready() -> void:
	get_parent().connect("drag_changed_received", _set_is_dragging)
	

func _process(_delta: float) -> void:
	if _draggable and not WinLoseManager.game_over:
		if Input.is_action_just_pressed("click"):
			AudioController.play_grab()
			_initial_pos = global_position
			_offset = get_global_mouse_position() - global_position
			drag_changed_sent.emit(true)
			
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - _offset
			
		elif Input.is_action_just_released("click"):
			drag_changed_sent.emit(false)
			
			if _is_inside_dropable:
				if _hovered_object != null:
					DragManager.available_chocolate_spots.append(_current_object)
					DragManager.available_chocolate_spots.erase(_hovered_object)
					
					if _hovered_object.is_in_group(DragManager.customer_group):
						_hovered_object.want_item_collision("CHOCOLATE")
						queue_free()
					else:
						_current_object = _hovered_object
						var tween = get_tree().create_tween()
						tween.tween_property(self, "position",_hovered_object.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position",_initial_pos, 0.2).set_ease(Tween.EASE_OUT)
	
	
func _set_is_dragging(new_is_dragging : bool) -> void:
	_is_dragging = new_is_dragging
	
	
func _on_mouse_entered() -> void:
	if not _is_dragging:
		_draggable = true


func _on_mouse_exited() -> void:
	if not _is_dragging:
		_draggable = false


func _on_body_entered(body: Node2D) -> void:
	if _current_object == null:
		_initial_pos = global_position
		_is_inside_dropable = true
		_current_object = body
	elif DragManager.available_chocolate_spots.has(body):
		_is_inside_dropable = true
		_hovered_object = body
		body.modulate = Color(Color.GRAY, 0.8)
	elif body.is_in_group(DragManager.dropable_chocolate_group) and body.is_in_group(DragManager.customer_group):
		_is_inside_dropable = true
		_hovered_object = body
		body.modulate = Color(Color.GRAY, 1)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(DragManager.dropable_chocolate_group):
		_is_inside_dropable = false
		
		if body.is_in_group(DragManager.customer_group):
			body.modulate = Color(Color.WHITE, 1)
		else:
			body.modulate = Color(Color.SLATE_GRAY, 0.5)
			
