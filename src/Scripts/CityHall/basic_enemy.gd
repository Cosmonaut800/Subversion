extends CharacterBody3D

@export var player: CharacterBody3D
@export var speed := 5.0

@onready var nav_agent := $NavigationAgent3D

func _physics_process(delta: float) -> void:
	nav_agent.set_target_position(player.position)
	
	velocity = speed * (nav_agent.get_next_path_position() - global_position).normalized()
	move_and_slide()
