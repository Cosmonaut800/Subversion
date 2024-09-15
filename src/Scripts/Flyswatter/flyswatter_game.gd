extends Node3D

@export var time_limit := 60.0
@export var first_wasp_time := 30.0
@export var wasp_interval := 15.0

@onready var swatter := $Swatter
@onready var fly_spawner := $FlySpawner
@onready var wasp_spawner := $WaspSpawner
@onready var game_panel := $CanvasLayer/Control/Panel
@onready var time_label := $CanvasLayer/Control/Panel/Time
@onready var score_label := $CanvasLayer/Control/Panel/Score
@onready var lives_label := $CanvasLayer/Control/Panel/Lives
@onready var finish_panel := $CanvasLayer/Control/Finished
@onready var final_score_label := $CanvasLayer/Control/Finished/FinalScore
@onready var game_over := $CanvasLayer/Control/GameOver
@onready var ambience := $Ambience
@onready var camera := $Camera3D
@onready var bg_music: AudioStreamPlayer3D = $bg_music
@onready var game_over_music: AudioStreamPlayer3D = $GameOver

var tween: Tween

var elapsed_time := 0.0
var finished := false

signal won_minigame
signal lost_minigame

func update_timers():
	wasp_spawner.first_spawn_timer.wait_time = first_wasp_time
	wasp_spawner.spawn_timer.wait_time = wasp_interval
	wasp_spawner.first_spawn_timer.start()

func _process(delta: float) -> void:
	var time_left = time_limit - elapsed_time
	time_label.set_text("%1d:%02d" % [time_left/60.0, fmod(time_left, 60.0)])
	score_label.set_text("Score: %d" % swatter.score)
	lives_label.set_text("Lives: %d" % swatter.lives)
	
	elapsed_time += delta
	if not finished and elapsed_time > time_limit:
		finished = true
		finish_game()

func finish_game():
	if swatter.tracking:
		var audio_tween = create_tween()
		audio_tween.tween_property(ambience, "volume_db", -80.0, 3.0)
		game_panel.set_visible(false)
		finish_panel.set_visible(true)
		final_score_label.set_text("Final Score: %d" % swatter.score)
		swatter.tracking = false
		fly_spawner.max_flies = 0
		wasp_spawner.active = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func lose_game():
	if swatter.tracking:
		var audio_tween = create_tween()
		audio_tween.tween_property(ambience, "volume_db", -80.0, 3.0)
		game_panel.set_visible(false)
		game_over.set_visible(true)
		swatter.tracking = false
		fly_spawner.max_flies = 0
		wasp_spawner.active = false
		bg_music.stop()
		game_over_music.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_swatter_lost_life() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	lives_label.label_settings.font_color = Color.RED
	tween.tween_property(lives_label, "label_settings:font_color", Color.WHITE, 1.0)
	
	if swatter.lives < 1:
		lose_game()

func _on_continue_pressed() -> void:
	won_minigame.emit()

func _on_try_again_pressed() -> void:
	lost_minigame.emit()
