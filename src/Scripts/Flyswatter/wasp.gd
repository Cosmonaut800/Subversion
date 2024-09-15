extends CharacterBody3D

@export var target: Node3D
@export var speed := 10.0

@onready var buzz := $Buzz

var parent_spawner: Node3D = null
var offset := Vector3(0.0, -0.175, 0.0)

func _ready():
	var tween = create_tween()
	tween.tween_property(buzz, "volume_db", 3.0, 4.0)
	position = Vector3(randf_range(-0.5, 0.5), 0.8, 0.0)

func _physics_process(delta):
	velocity = speed * delta * ((target.position + offset) - position).normalized()
	move_and_slide()
	
	basis = basis.looking_at(target.position + offset - position, Vector3.BACK)

func kill():
	if parent_spawner:
		parent_spawner.wasps.erase(self)
	
	queue_free()
