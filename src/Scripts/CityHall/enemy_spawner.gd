extends Node3D

@export var max_enemies := 3
@export var active := true
@export var player: CharacterBody3D

@onready var spawn_timer := $SpawnTimer

var enemy_template := preload("res://src/Scenes/CityHall/BasicEnemy.tscn")
var enemies: Array[CharacterBody3D] = []

func _ready():
	if active:
		spawn_timer.start()

func _process(_delta):
	if active and spawn_timer.is_stopped() and enemies.size() < max_enemies:
		spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	enemies.append(enemy_template.instantiate())
	enemies[-1].player = player
	enemies[-1].parent_spawner = self
	add_child(enemies[-1])
