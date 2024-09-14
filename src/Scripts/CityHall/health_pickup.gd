extends Node3D

@export var heal_amount := 50.0

@onready var pivot := $Pivot

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.health += 50.0
	queue_free()


func _process(delta):
	pivot.basis = pivot.basis.rotated(Vector3.UP, 1.5 * delta)
