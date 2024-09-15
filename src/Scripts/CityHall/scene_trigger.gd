extends Node3D

var activated := false

func activate():
	activated = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if activated:
		print("Scene ended!")
