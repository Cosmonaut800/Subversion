extends Node3D

@export var first_wasp_time := 30.0
@export var wasp_interval := 16.0

var minigame_template = preload("res://src/Scenes/Flyswatter/flyswatter_game.tscn")
var minigame: Node3D

signal won_minigame

func _ready():
	minigame = minigame_template.instantiate()
	add_child(minigame)
	minigame.won_minigame.connect(_on_flyswatter_game_won_minigame)
	minigame.lost_minigame.connect(_on_flyswatter_game_lost_minigame)
	minigame.first_wasp_time = first_wasp_time
	minigame.wasp_interval = wasp_interval
	minigame.update_timers()

func _on_flyswatter_game_won_minigame() -> void:
	Global.player_can_move = true
	won_minigame.emit()

func _on_flyswatter_game_lost_minigame() -> void:
	minigame.queue_free()
	minigame = minigame_template.instantiate()
	add_child(minigame)
	minigame.camera.set_current(true)
	minigame.won_minigame.connect(_on_flyswatter_game_won_minigame)
	minigame.lost_minigame.connect(_on_flyswatter_game_lost_minigame)
	minigame.first_wasp_time = first_wasp_time
	minigame.wasp_interval = wasp_interval
	minigame.update_timers()
