extends Node3D

var activated := false

signal scene_ended

func activate():
	activated = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if activated:
		scene_ended.emit()
