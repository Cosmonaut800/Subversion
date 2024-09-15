extends State
@onready var anim_tree := $"../../AnimationTree"
@export var idle_state : State
func enter() -> void:
	parent.velocity.x = 0
	parent.velocity.z = 0
	anim_tree.set("parameters/conditions/stop", true)
	anim_tree.set("parameters/conditions/run", false)
	super()
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	if Global.is_talking == false:
		return idle_state
	return null

func process_physics(_delta: float) -> State:
	return null
