extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input( event ):
	
	if not ( event is InputEventKey and event.pressed ) :
		return
	
	var keep_on_pressed = event.is_action_pressed("ui_accept") or event.is_action_pressed( 'fire' )
	if keep_on_pressed :
		GLOBAL.goto_scene( GLOBAL.SCENE_START_PATH )
