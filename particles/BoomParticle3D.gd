extends GPUParticles3D

var started = false;

signal particle_ended;

func _ready():
	pass


func _process(_delta) :
	if not is_emitting() and started:
		started = false
		particle_ended.emit()

func start():
	emitting = true
	started = true
