extends Control

var fade_in : bool = false
var fade_out : bool = false

var fade_duration : float = 2.0
var waiting_time : float = 2.0
var current_splash : int = 0


func _ready() :
	show_next_splash()


func _process( delta ) :
	if not visible :
		return;

	if fade_in :
		var current_alpha = $WhitePage.color[ 3 ]
		$WhitePage.color[ 3 ] += fade_duration * delta
		if current_alpha >= 1 :
			fade_in = false

	if fade_out :
		var current_alpha = $WhitePage.color[ 3 ]
		$WhitePage.color[ 3 ] -= fade_duration * delta
		if current_alpha <= 0 :
			fade_out = false


func show_next_splash() :
	var prev_node = get_node_or_null( 'Splash' + str( current_splash ) )
	if prev_node == null  :
		hide_white_page()
		await get_tree().create_timer( waiting_time ).timeout
		current_splash = current_splash + 1
		show_next_splash()
		return

	show_white_page()
	await get_tree().create_timer( 2.0 ).timeout

	get_node('Splash' + str( current_splash ) ).hide()
	var next_node = get_node_or_null( 'Splash' + str( current_splash + 1 ) )
	if next_node != null : 
		get_node('Splash' + str( current_splash + 1 ) ).show()
		hide_white_page()
		await get_tree().create_timer( waiting_time ).timeout
		current_splash = current_splash + 1
		show_next_splash()
	else :
		GLOBAL.goto_scene( GLOBAL.SCENE_MAIN_PATH )


func pass_fast() :
	fade_duration = 1


func show_white_page() :
	fade_in = true


func hide_white_page() :
	fade_out = true


func _unhandled_input( event ):
	
	if not ( event is InputEventKey and event.pressed ) :
		return

	GLOBAL.goto_scene( GLOBAL.SCENE_MAIN_PATH )
