extends Node3D

@export var max_flies := 12

@onready var spawn_timer := $SpawnTimer

var flies: Array[CharacterBody3D]
var fly_template := preload("res://src/Scenes/Flyswatter/fly.tscn")

func _on_spawn_timer_timeout() -> void:
	spawn_timer.start()
	
	if flies.size() < max_flies:
		flies.append(fly_template.instantiate())
		add_child(flies[-1])
		flies[-1].parent_spawner = self
	
