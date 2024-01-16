extends Node

func _ready():
	if not $BG_start.playing :
		$BG_start.play();


func _on_audio_stream_player_finished():
	$BG_loop.play()


func _on_bg_loop_finished():
	$BG_loop.play()
