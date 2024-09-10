extends CharacterBody3D


const SPEED = 6.0
const ACCEL = 30.0
const DECEL = 25.0
const JUMP_HEIGHT = 1.0

@onready var yaw := $YawPivot
@onready var pitch := $YawPivot/PitchPivot
@onready var camera := $YawPivot/PitchPivot/Camera3D
@onready var cam_target := $YawPivot/PitchPivot/CameraTarget
@onready var ray := $YawPivot/PitchPivot/RayCast3D
@onready var action_wait := $ActionWait
@onready var footstep_timer := $Audio/FootstepTimer
@onready var footsteps := [	$Audio/footstep1,
							$Audio/footstep2,
							$Audio/footstep3,
							$Audio/footstep4]

var previous_basis: Basis
var previous_position: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var horizontal_speed := 1.0
var vertical_speed := 1.0
var mouse_sensitivity := 0.002
var yaw_input := 0.0
var pitch_input := 0.0

var state := 0
enum STATE {FREE}

var focused := true

var can_step := true
var can_use := true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state = STATE.FREE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (yaw.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction.y = 0.0
	if state == STATE.FREE:
		if direction:
			velocity.x = move_toward(velocity.x, SPEED * direction.x, abs(direction.x) * ACCEL * delta)
			velocity.z = move_toward(velocity.z, SPEED * direction.z, abs(direction.z) * ACCEL * delta)
		
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				velocity.y += sqrt(2.0 * gravity * JUMP_HEIGHT)
			
			if not direction:
				decelerate(delta)
	else:
		velocity = Vector3.ZERO
	
	if can_step && get_last_motion().length() > 0.05:
		var index = randi_range(0, 3)
		can_step = false
		footstep_timer.start()
		footsteps[index].pitch_scale = randf_range(0.9, 1.1)
		footsteps[index].play()
	
	move_and_slide()

func _process(_delta):
	if state == STATE.FREE:
		yaw.rotate_y(yaw_input)
		pitch.rotate_x(pitch_input)
		pitch.rotation.x = clamp(pitch.rotation.x, -1.5, 1.5)
		yaw_input = 0.0
		pitch_input = 0.0
	
	if Input.is_action_just_pressed("ui_cancel"):
		if focused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		focused = !focused

func decelerate(delta: float):
	velocity.x = move_toward(velocity.x, 0, abs(velocity.normalized().x) * DECEL * delta)
	velocity.z = move_toward(velocity.z, 0, abs(velocity.normalized().z) * DECEL * delta)

func _unhandled_input(event):
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				yaw_input = -event.relative.x * mouse_sensitivity * horizontal_speed
				pitch_input = -event.relative.y * mouse_sensitivity * vertical_speed

func _on_footstep_timer_timeout():
	can_step = true
