extends Area3D
@onready var dialogue_start := $DialogueStarter
@onready var parent := $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		dialogue_start.start_dialogue()
		parent.queue_free()
