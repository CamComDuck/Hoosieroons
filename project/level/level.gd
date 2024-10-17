extends Node2D

var _available_customer_spots : Array = []
var _busy_customer_spots : Array = []
var _chocolate_refillable := true
var _lollipop_refillable := true

@onready var customer_spot_1: Marker2D = $CustomerSpot1
@onready var customer_spot_2: Marker2D = $CustomerSpot2
@onready var customer_spot_3: Marker2D = $CustomerSpot3
@onready var customer_spot_4: Marker2D = $CustomerSpot4
@onready var customer_respawn_timer: Timer = $CustomerRespawnTimer
@onready var chocolate_refill_button: Button = $ChocolateRefillButton
@onready var chocolate_refill_progress: TextureProgressBar = $ChocolateRefillButton/ChocolateRefillProgress
@onready var chocolate_refill_timer: Timer = $ChocolateRefillButton/ChocolateRefillTimer
@onready var lollipop_refill_button: Button = $LollipopRefillButton
@onready var lollipop_refill_progress: TextureProgressBar = $LollipopRefillButton/LollipopRefillProgress
@onready var lollipop_refill_timer: Timer = $LollipopRefillButton/LollipopRefillTimer
@onready var chocolate_spot_1: ChocolateSpot = $ChocolateSpot1
@onready var chocolate_spot_2: ChocolateSpot = $ChocolateSpot2
@onready var chocolate_spot_3: ChocolateSpot = $ChocolateSpot3
@onready var lollipop_spot_1: LollipopSpot = $LollipopSpot1
@onready var lollipop_spot_2: LollipopSpot = $LollipopSpot2
@onready var lollipop_spot_3: LollipopSpot = $LollipopSpot3

func _ready() -> void:
	_change_button_theme(chocolate_refill_button, Color.GREEN, Color.DARK_GREEN)
	_change_button_theme(lollipop_refill_button, Color.GREEN, Color.DARK_GREEN)
	
	_available_customer_spots.clear()
	_available_customer_spots.append(customer_spot_1)
	_available_customer_spots.append(customer_spot_2)
	_available_customer_spots.append(customer_spot_3)
	_available_customer_spots.append(customer_spot_4)
	
	DragManager.available_chocolate_spots.clear()
	DragManager.available_chocolate_spots.append(chocolate_spot_1)
	DragManager.available_chocolate_spots.append(chocolate_spot_2)
	DragManager.available_chocolate_spots.append(chocolate_spot_3)
	
	DragManager.available_lollipop_spots.clear()
	DragManager.available_lollipop_spots.append(lollipop_spot_1)
	DragManager.available_lollipop_spots.append(lollipop_spot_2)
	DragManager.available_lollipop_spots.append(lollipop_spot_3)
	
	_spawn_customer()
	

func _physics_process(_delta: float) -> void:
	chocolate_refill_progress.value = (chocolate_refill_timer.time_left / chocolate_refill_timer.wait_time) * 100
	lollipop_refill_progress.value = (lollipop_refill_timer.time_left / lollipop_refill_timer.wait_time) * 100
	
	for i in _busy_customer_spots.size() - 1:
		if _busy_customer_spots[i].get_child_count() == 0:
			_available_customer_spots.append(_busy_customer_spots.pop_at(i))

func _spawn_customer() -> void:
	var random_spot = randi_range(0, _available_customer_spots.size() - 1)
	var customer_spot = _available_customer_spots.pop_at(random_spot)
	_busy_customer_spots.append(customer_spot)
	
	var customer = preload("res://customer/customer.tscn").instantiate()
	customer_spot.add_child(customer)
	customer.global_position = customer_spot.global_position
	_restart_respawn_timer()
	
	
func _restart_respawn_timer() -> void:
	var random_time = randf_range(1.5, 3.25)
	customer_respawn_timer.wait_time = random_time
	customer_respawn_timer.start()
	

func _change_button_theme(button : Button, color_light : Color, color_dark : Color) -> void:
	button.add_theme_color_override("font_hover_color", color_light)
	button.add_theme_color_override("font_pressed_color", color_dark)
	button.add_theme_color_override("icon_hover_color", color_light)
	button.add_theme_color_override("icon_pressed_color", color_dark)
	

func _on_customer_respawn_timer_timeout() -> void:
	if _available_customer_spots.is_empty():
		_restart_respawn_timer()
	else:
		_spawn_customer()


func _on_chocolate_refill_button_pressed() -> void:
	if _chocolate_refillable:
		for i in DragManager.available_chocolate_spots.size():
			var chocolate = preload("res://chocolate/chocolate.tscn").instantiate()
			add_child(chocolate)
			chocolate.global_position = DragManager.available_chocolate_spots[i].global_position
			
		DragManager.available_chocolate_spots.clear()
		_chocolate_refillable = false
		_change_button_theme(chocolate_refill_button, Color.RED, Color.DARK_RED)
		chocolate_refill_timer.start()


func _on_chocolate_refill_timer_timeout() -> void:
	_chocolate_refillable = true
	_change_button_theme(chocolate_refill_button, Color.GREEN, Color.DARK_GREEN)
	chocolate_refill_timer.stop()
	


func _on_lollipop_refill_button_pressed() -> void:
	if _lollipop_refillable:
		for i in DragManager.available_lollipop_spots.size():
			var lollipop = preload("res://lollipop/lollipop.tscn").instantiate()
			add_child(lollipop)
			lollipop.global_position = DragManager.available_lollipop_spots[i].global_position
			
		DragManager.available_lollipop_spots.clear()
		_lollipop_refillable = false
		_change_button_theme(lollipop_refill_button, Color.RED, Color.DARK_RED)
		lollipop_refill_timer.start()


func _on_lollipop_refill_timer_timeout() -> void:
	_lollipop_refillable = true
	_change_button_theme(lollipop_refill_button, Color.GREEN, Color.DARK_GREEN)
	lollipop_refill_timer.stop()
