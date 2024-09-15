extends Node3D

signal player_died
signal player_won

func _on_first_person_player_died() -> void:
	player_died.emit()

func _on_scene_trigger_scene_ended() -> void:
	Global.player_can_move = false
	player_won.emit()
