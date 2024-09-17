extends Node3D
@onready var camera := $Camera3D
@onready var camera_stopper := $camera_stopper
@onready var start_button := $CanvasLayer/StartButton
@onready var color_overlay := $CanvasLayer/ColorOverlay
@onready var title_animation := $AnimationPlayer
var start_game = false
# Called when the node enters the scene tree for the first time.
func _ready():
	title_animation.play("Fade_In")
	get_tree().create_tween().tween_property(camera, "position:x", camera_stopper.position.x,120)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not title_animation.is_playing():
		color_overlay.hide()
	
	if start_game and not title_animation.is_playing():
		get_tree().change_scene_to_file("res://src/Scenes/main.tscn")

func _on_start_button_pressed():
	color_overlay.show()
	start_game = true
	title_animation.play("Fade_Out")
	

	
	
