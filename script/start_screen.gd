extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	blink_start_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func blink_start_text() :
	$Start.visible = ! $Start.visible
	await get_tree().create_timer( 0.6 ).timeout 
	blink_start_text()


func _unhandled_input( event ):
	if event is InputEventKey and event.pressed :
		GLOBAL.start_game()
