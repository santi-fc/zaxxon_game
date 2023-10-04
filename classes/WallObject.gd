class_name WallObject extends StaticBody3D

var sparks_particle = preload("res://particles/sparks.tscn")

@export var multiplier = 1

@export var WallObject = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Deprecated
func get_fired( _position ) :
	var spark = sparks_particle.instantiate()
	_position.y = _position.y - 0.2
	_position.x = _position.x - 0.1 
	_position.z = -0.2
	
	spark.get_children()[0].position = _position
	spark.get_children()[0].one_shot = true
	add_child( spark )
