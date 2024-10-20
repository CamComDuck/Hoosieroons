extends Node2D

signal eat_finished

func _ready() -> void:
	$BackgroundMusic.play()
	

func play_bg_chatter() -> void:
	$BackgroundChatter.play()
	

func stop_bg_chatter() -> void:
	$BackgroundChatter.stop()
	
	
func play_button() -> void:
	$Button.play()
	
	
func play_doorbell() -> void:
	$Doorbell.play()
	
	
func play_eat() -> void:
	$Eat.play()
	await $Eat.finished
	eat_finished.emit()
	
	
func play_grab() -> void:
	$Grab.play()
	
	
func play_thanks() -> void:
	$Thanks.play()
	
