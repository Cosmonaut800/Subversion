extends Node3D

@onready var village := $Village
@onready var color_rect: ColorRect = $CanvasLayer/Control/ColorRect
@onready var transition_timer: Timer = $TransitionTimer
@onready var transition_timer_2: Timer = $TransitionTimer2
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var city_hall_template := preload("res://src/Scenes/CityHall/city_hall.tscn")
var city_hall: Node3D
var ending_template: Node = null

func _on_village_start_fps() -> void:
	var tween = create_tween()
	
	tween.tween_property(color_rect, "color", Color.BLACK, 0.75)
	tween.tween_property(color_rect, "color", Color.TRANSPARENT, 0.75)
	
	canvas_layer.set_visible(true)
	transition_timer.start()
	transition_timer_2.start()

func _on_transition_timer_timeout() -> void:
	city_hall = city_hall_template.instantiate()
	add_child(city_hall)
	city_hall.player_died.connect(reset_city_hall)
	village.queue_free()

func _on_transition_timer_2_timeout() -> void:
	canvas_layer.set_visible(false)

func reset_city_hall():
	city_hall.queue_free()
	city_hall = city_hall_template.instantiate()
	add_child(city_hall)
	city_hall.player_died.connect(reset_city_hall)
