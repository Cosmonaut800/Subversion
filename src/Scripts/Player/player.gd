extends Entity

@export var movement_speed = 20.0
@onready var pivot = $Character

#func _physics_process(delta):
#
	## Get the input direction and handle the movement/deceleration.
	#var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#
	#if direction:
		## Move in the input direction.
		#velocity.x = direction.x * movement_speed
		#velocity.z = direction.z * movement_speed
		#
		## Smoothly rotate the pivot to face the movement direction.
		#var target_rotation = Basis().looking_at(direction, Vector3.UP)
		#pivot.basis = pivot.basis.slerp(target_rotation, ROTATION_SPEED * delta)
	#else:
		## Decelerate to a stop.
		#velocity.x = move_toward(velocity.x, 0, movement_speed)
		#velocity.z = move_toward(velocity.z, 0, movement_speed)
#
	## Apply movement.
	#move_and_slide()
