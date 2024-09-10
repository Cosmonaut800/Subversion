extends State

@export var move_state: State
var can_move : bool = true

func enter() -> void:
	#parent.animation_player.play(animation_name)
	parent.velocity.x = 0
	parent.velocity.z = 0

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	var key_pressed : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if can_move and key_pressed.x != 0 || key_pressed.y != 0:
		return move_state
	
	return null

func process_physics(_delta: float) -> State:
	return null
