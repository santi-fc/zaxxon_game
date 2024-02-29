extends RayCast3D

var level_fininshed_notified : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void :
	self.position.y = GLOBAL.player.position.y
	
	if self.is_colliding() and not level_fininshed_notified :
		level_fininshed_notified = true
		get_parent().get_parent().level_finished()
