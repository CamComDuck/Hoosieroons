class_name Customer
extends StaticBody2D

var _want_item : String
var _items_left : int

@onready var item_img: TextureRect = $WantBubble/VBoxContainer/HBoxContainer/ItemImg
@onready var item_count: Label = $WantBubble/VBoxContainer/HBoxContainer/ItemCount
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var happiness_timer: Timer = $HappinessTimer
@onready var progress_bar: ProgressBar = $WantBubble/VBoxContainer/ProgressBar

func _ready() -> void:
	sprite_2d.modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))

	var random_item = randi_range(0, 1)
	_items_left = randi_range(1, 3)
	item_count.text = "x " + str(_items_left)
	
	if random_item == 0:
		_want_item = "CHOCOLATE"
		add_to_group(DragManager.dropable_chocolate_group)
		item_img.texture = load("res://chocolate/chocolate.png")
	else:
		_want_item = "LOLLIPOP"
		add_to_group(DragManager.dropable_lollipop_group)
		item_img.texture = load("res://lollipop/lollipop.png")
		
	happiness_timer.wait_time = randf_range(7, 11)
	happiness_timer.start()


func _physics_process(_delta: float) -> void:
	progress_bar.value = (happiness_timer.time_left / happiness_timer.wait_time) * 100
	

func want_item_collision(item : String) -> void:
	if item == _want_item:
		_items_left -= 1
		if _items_left > 0:
			item_count.text = "x " + str(_items_left)
		else:
			queue_free()

func _on_happiness_timer_timeout() -> void:
	queue_free()
