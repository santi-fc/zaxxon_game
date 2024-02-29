extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# $Sound/MusicIntro.play()
	GLOBAL.play_song( 'intro' )
	$MainMenu/StartButton.grab_focus()
	$OptionMenu/SliderVolumen.value = GLOBAL.current_master_volume
	refresh_volume_number()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void :
	pass

func _on_start_button_pressed() -> void :
	GLOBAL.stop_song()
	GLOBAL.start_game()

func _on_exit_button_pressed() -> void :
	GLOBAL.exit_game()

func _on_option_button_pressed() -> void :
	$MainMenu.hide()
	$OptionMenu.show()

func refresh_volume_number() -> void :
	# Transform min-value-max into percentatge
	var min_value : float = $OptionMenu/SliderVolumen.min_value
	var max_value : float = $OptionMenu/SliderVolumen.max_value
	var current_value : float = $OptionMenu/SliderVolumen.value
	var percent : float = ( current_value - min_value ) / ( max_value - min_value ) * 100
	var text = 'MUTE' if floor( percent ) == 0 else str( floor( percent ) ) + "%"
	$OptionMenu/Volumen_Numero.text = text


func _on_slider_volumen_value_changed( value ) -> void :
	GLOBAL.change_volume( GLOBAL.master_sound_bus, value )
	refresh_volume_number()


func _on_volver_pressed():
	GLOBAL.save_config()
	$MainMenu.show()
	$OptionMenu.hide()
