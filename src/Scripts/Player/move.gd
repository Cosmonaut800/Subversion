extends State


@export var idle_state: State
@export var interact_state : State

@export var rotation_speed = 8.0
@export var movement_speed = 25.0
@onready var character = $"../../Character"
@onready var anim_tree := $"../../AnimationTree"
func enter() -> void:
	print(Global.is_talking)
	#parent.animation_player.play(animation_name)
	anim_tree.set("parameters/conditions/stop", false)
	anim_tree.set("parameters/conditions/run", true)
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Global.is_talking:
		return interact_state
	return null

func process_physics(_delta: float) -> State:

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	parent.velocity.x = direction.x * movement_speed
	parent.velocity.z = direction.z * movement_speed
	if not parent.is_on_floor():
		parent.velocity.y -= 50 * _delta
	else:
		parent.velocity.y = 0		
	# Smoothly rotate the pivot to face the movement direction.
	var target_rotation = Basis().looking_at(direction, Vector3.UP)
	character.basis = character.basis.slerp(target_rotation, rotation_speed * _delta)
	parent.move_and_slide()
	
	if not direction:
		return idle_state
	
	return null
