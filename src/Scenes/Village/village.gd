extends Node

@onready var village_camera := $WorldEnvironment/Player/CameraPivot/Camera3D

var minigame1_template = preload("res://src/Scenes/Flyswatter/minigame1.tscn")
var minigame1: Node3D
var minigame1_started := false

var minigame2_template = preload("res://src/Scenes/Flyswatter/minigame2.tscn")
var minigame2: Node3D
var minigame2_started := false

var fps_started := false

signal start_fps

func _ready():
	Global.game_one_completed = true
	Global.game_two_completed = true

func _process(_delta):
	if minigame1_started and not Global.is_talking:
		minigame1 = minigame1_template.instantiate()
		add_child(minigame1)
		minigame1.won_minigame.connect(on_won_minigame1)
		minigame1.minigame.camera.set_current(true)
		minigame1_started = false
	
	if minigame2_started and not Global.is_talking:
		minigame2 = minigame2_template.instantiate()
		add_child(minigame2)
		minigame2.won_minigame.connect(on_won_minigame2)
		minigame2.minigame.camera.set_current(true)
		minigame2_started = false
	
	if fps_started and not Global.is_talking:
		start_fps.emit()
		fps_started = false

func on_won_minigame1():
	village_camera.set_current(true)
	minigame1.queue_free()

func on_won_minigame2():
	village_camera.set_current(true)
	minigame2.queue_free()

func _on_dialogue_starter_minigame_1_started() -> void:
	minigame1_started = true

func _on_dialogue_starter_minigame_2_started() -> void:
	minigame2_started = true

func _on_dialogue_starter_fps_started() -> void:
	fps_started = true
