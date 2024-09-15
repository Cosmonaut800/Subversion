extends Node3D

@export var camera: Camera3D

@onready var pivot := $Pivot
@onready var killzone := $killzone

var tween: Tween
var score := 0
var lives := 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	var position3D = camera.project_position(get_viewport().get_mouse_position(), 0.8)
	
	position = position3D
	
	if Input.is_action_just_pressed("primary_fire"):
		swat()

func swat():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(pivot, "basis", pivot.basis.looking_at(position + Vector3(0.0, -0.3, -1.0)), 0.1)
	tween.tween_property(pivot, "basis", pivot.basis.looking_at(position + Vector3(0.0, 0.0, -1.0)), 0.1)
	
	if killzone.has_overlapping_bodies():
		#Play splat sound here
		pass
	
	for body in killzone.get_overlapping_bodies():
		body.kill()
		score += 1
