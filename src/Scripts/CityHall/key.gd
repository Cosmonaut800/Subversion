extends Node3D

@onready var pivot = $Pivot

signal picked_up

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pivot.basis = pivot.basis.rotated(Vector3.UP, PI * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	picked_up.emit()
