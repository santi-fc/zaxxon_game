extends RayCast3D

@onready var point_mesh = $Punt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	force_raycast_update()
	if is_colliding() :
		var cast_point = to_local(get_collision_point())
		point_mesh.position.z = cast_point.z
		point_mesh.show()
	else :
		point_mesh.hide()
