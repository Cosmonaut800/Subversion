extends Node3D
@onready var dialogue_starter := $DialogueStarter

# Called when the node enters the scene tree for the first time.
func _ready():
	dialogue_starter.start_dialogue()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
