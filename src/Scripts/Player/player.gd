extends Entity

@export var movement_speed = 20.0
@onready var pivot = $Character

func rotate_npc(entity: Node3D, _delta: float):
	var direction = (self.global_transform.origin - entity.global_transform.origin).normalized()
	var target_rotation = Basis().looking_at(direction, Vector3.UP)
	entity.basis = entity.basis.slerp(target_rotation, 8 * _delta)
