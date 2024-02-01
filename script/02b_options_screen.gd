extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	$SliderVolumen.value = GLOBAL.current_master_volume
	refresh_volume_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void :
	pass

func _on_exit_button_pressed() -> void :
	GLOBAL.go_to_start()

func refresh_volume_number() -> void :
	$Volumen_Numero.text = str($SliderVolumen.value)


func _on_slider_volumen_value_changed( value ) -> void :
	GLOBAL.change_volume( GLOBAL.master_sound_bus, value )
	refresh_volume_number()
