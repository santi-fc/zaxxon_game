extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	blink_start_text()
	$Sound/MusicIntro.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func blink_start_text() :
	$Start.visible = ! $Start.visible
	await get_tree().create_timer( 0.6 ).timeout 
	blink_start_text()


func _unhandled_input( event ):
	if ( event is InputEventKey or event is InputEventJoypadButton ) and event.pressed :
		$Sound/MusicIntro.stop()
		GLOBAL.start_game()
