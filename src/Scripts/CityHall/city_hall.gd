extends Node3D

signal player_died

func _on_first_person_player_died() -> void:
	player_died.emit()
