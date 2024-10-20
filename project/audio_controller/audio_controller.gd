extends Node2D

func play_bg_chatter() -> void:
	$BackgroundChatter.play()
	

func pause_bg_chatter() -> void:
	$BackgroundChatter.stream_paused = not $BackgroundChatter.stream_paused
	
	
func play_bg_music() -> void:
	$BackgroundMusic.play()
	
	
func play_button() -> void:
	$Button.play()
	
	
func play_doorbell() -> void:
	$Doorbell.play()
	
	
func play_eat() -> void:
	$Eat.play()
	
	
func play_grab() -> void:
	$Grab.play()
	
	
func play_thanks() -> void:
	$Thanks.play()
	
