extends Node3D

@onready var model := $DoorPivot

var locked := false
var has_opened := false

func unlock():
	locked = false

func open():
	print("door opening")
	if not locked and not has_opened:
		var tween = create_tween()
		tween.tween_property(model, "basis", model.basis.rotated(Vector3.UP, 1.5), 0.8)
		has_opened = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	open()
