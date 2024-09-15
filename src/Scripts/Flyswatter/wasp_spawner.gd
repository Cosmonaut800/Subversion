extends Node3D

@export var target: Node3D

@onready var first_spawn_timer := $FirstSpawnTimer
@onready var spawn_timer := $SpawnTimer

var wasp_template := preload("res://src/Scenes/Flyswatter/wasp.tscn")
var wasps: Array[CharacterBody3D] = []
var active := true

func spawn_wasp():
	if active:
		wasps.append(wasp_template.instantiate())
		add_child(wasps[-1])
		wasps[-1].parent_spawner = self
		wasps[-1].target = target

func _on_first_spawn_timer_timeout() -> void:
	spawn_wasp()
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_wasp()
	spawn_timer.start()
