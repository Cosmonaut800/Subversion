extends CharacterBody3D

const SPAWN_DISTANCE := 0.75
const CULL_DISTANCE := 0.8


@export var speed := 20.0

var spawn_position: Vector3
var elapsed_time := 0.0
var target := Vector3.ZERO

var deflection_amplitude
var deflection_frequency

var parent_spawner: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_angle := randf_range(0.0, 2*PI)
	spawn_position = Vector3(SPAWN_DISTANCE*cos(start_angle), SPAWN_DISTANCE*sin(start_angle), 0.0)
	position = spawn_position
	
	target.x = randf_range(-0.3, 0.3)
	target.y = randf_range(-0.3, 0.3)
	
	deflection_amplitude = randf_range(0.0, PI/2.0)
	deflection_frequency = randf_range(0.5*PI, 1.5*PI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	elapsed_time += delta
	
	velocity = Vector3.ZERO
	velocity.y = speed * delta
	velocity += Vector3(speed*delta*sin(deflection_amplitude*sin(deflection_frequency*elapsed_time)), 0.0, 0.0)
	velocity = velocity.rotated(Vector3.BACK, Vector3(0.0, 1.0, 0.0).signed_angle_to(target - spawn_position, Vector3.BACK))
	move_and_slide()
	
	if (position - target).length() > CULL_DISTANCE:
		kill()
	

func kill():
	
	if parent_spawner:
		parent_spawner.flies.erase(self)
		
	
	queue_free()
