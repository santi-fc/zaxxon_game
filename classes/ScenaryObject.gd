class_name ScenaryObject extends StaticBody3D

@export var health = 3  # default health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_shoot() :
	health = health - 1
	if ( health == 0 ) :
		hide()
		#remove_child(self)
		queue_free()
