extends State

func enter() -> void:
	#parent.animation_player.play(animation_name)
	super()
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
