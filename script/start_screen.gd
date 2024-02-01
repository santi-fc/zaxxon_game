extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# $Sound/MusicIntro.play()
	GLOBAL.play_song( 'intro' )
	$MainMenu/StartButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void :
	pass

func _on_start_button_pressed() -> void :
	GLOBAL.stop_song()
	GLOBAL.start_game()

func _on_exit_button_pressed() -> void :
	GLOBAL.exit_game()

func _on_option_button_pressed() -> void :
	GLOBAL.go_to_options()
