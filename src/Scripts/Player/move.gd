extends State


@export var idle_state: State

@export var rotation_speed = 8.0
@export var movement_speed = 20.0
@onready var character = $"../../Character"

func enter() -> void:
	#parent.animation_player.play(animation_name)
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	parent.velocity.x = direction.x * movement_speed
	parent.velocity.z = direction.z * movement_speed
		
	# Smoothly rotate the pivot to face the movement direction.
	var target_rotation = Basis().looking_at(direction, Vector3.UP)
	character.basis = character.basis.slerp(target_rotation, rotation_speed * _delta)
	parent.move_and_slide()
	
	if not direction:
		return idle_state
	
	return null
