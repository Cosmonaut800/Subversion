extends CharacterBody3D


const SPEED := 6.0
const ACCEL := 30.0
const DECEL := 25.0
const JUMP_HEIGHT := 1.0
const AMMO_MAX := 2

@onready var yaw := $YawPivot
@onready var pitch := $YawPivot/PitchPivot
@onready var camera := $YawPivot/PitchPivot/Camera3D
@onready var cam_target := $YawPivot/PitchPivot/CameraTarget
@onready var gun_graphics := $YawPivot/PitchPivot/Camera3D/GunGraphics
@onready var bullet_graphics := $YawPivot/PitchPivot/Camera3D/BulletGraphics
@onready var muzzle_flash := $YawPivot/PitchPivot/Camera3D/MuzzleFlash
@onready var muzzle_flash_timer := $YawPivot/PitchPivot/Camera3D/MuzzleFlashTimer
@onready var reload_wait := $ReloadWait
@onready var footstep_timer := $Audio/FootstepTimer
@onready var footsteps := [	$Audio/footstep1,
							$Audio/footstep2,
							$Audio/footstep3,
							$Audio/footstep4]
@onready var gun_sfx := $Audio/Shotgun
@onready var reload_sfx := $Audio/Reload
@onready var raycasts := [	$YawPivot/PitchPivot/Rays/Ray1,
							$YawPivot/PitchPivot/Rays/Ray2,
							$YawPivot/PitchPivot/Rays/Ray3,
							$YawPivot/PitchPivot/Rays/Ray4,
							$YawPivot/PitchPivot/Rays/Ray5,
							$YawPivot/PitchPivot/Rays/Ray6,
							$YawPivot/PitchPivot/Rays/Ray7,
							$YawPivot/PitchPivot/Rays/Ray8,
							$YawPivot/PitchPivot/Rays/Ray9]
@onready var splatters := [	$YawPivot/PitchPivot/Rays/Splatter1,
							$YawPivot/PitchPivot/Rays/Splatter2,
							$YawPivot/PitchPivot/Rays/Splatter3,
							$YawPivot/PitchPivot/Rays/Splatter4,
							$YawPivot/PitchPivot/Rays/Splatter5,
							$YawPivot/PitchPivot/Rays/Splatter6,
							$YawPivot/PitchPivot/Rays/Splatter7,
							$YawPivot/PitchPivot/Rays/Splatter8,
							$YawPivot/PitchPivot/Rays/Splatter9]

var previous_basis: Basis
var previous_position: Vector3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var horizontal_speed := 1.0
var vertical_speed := 1.0
var mouse_sensitivity := 0.002
var yaw_input := 0.0
var pitch_input := 0.0

var true_pitch := 0.0
var recoil := 0.0
var recoil_tween: Tween
var gun_tween: Tween

var state := 0
enum STATE {FREE}

var focused := true

var can_step := true
var can_use := true
var ammo := 2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state = STATE.FREE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

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
	
	if Input.is_action_just_pressed("primary_fire") and ammo > 0 and reload_wait.is_stopped():
		shoot()
	
	if is_on_floor() && can_step && get_last_motion().length() > 0.05:
		var index = randi_range(0, 3)
		can_step = false
		footstep_timer.start()
		footsteps[index].pitch_scale = randf_range(0.9, 1.1)
		footsteps[index].play()
	
	move_and_slide()

func _process(_delta):
	if state == STATE.FREE:
		yaw.rotate_y(yaw_input)
		true_pitch += pitch_input
		true_pitch = clamp(true_pitch, -1.5, 1.5)
		pitch.rotation.x = true_pitch + recoil
		yaw_input = 0.0
		pitch_input = 0.0
	
	if ammo < AMMO_MAX and Input.is_action_just_pressed("reload") and reload_wait.is_stopped():
		reload_gun()
	
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

func shoot():
	var entity
	
	muzzle_flash.light_energy = 1.0
	muzzle_flash_timer.start()
	bullet_graphics.restart()
	
	for i in raycasts.size():
		raycasts[i].target_position.x = ((i % 3) - 1) * randf_range(4.0, 8.0)
		raycasts[i].target_position.y = (floor(i/3) - 1) * randf_range(4.0, 8.0)
		entity = raycasts[i].get_collider()
		if entity:
			splatters[i].global_position = raycasts[i].get_collision_point()
			splatters[i].process_material.direction = camera.global_basis.inverse() * raycasts[i].get_collision_normal() + Vector3.UP
			splatters[i].process_material.initial_velocity_min = 2.5
			splatters[i].process_material.initial_velocity_max = 2.5
			if entity.get_collision_layer_value(3):
				splatters[i].draw_pass_1.surface_get_material(0).albedo_color = Color.DARK_RED
				splatters[i].process_material.initial_velocity_min += raycasts[i].get_collision_normal().dot(entity.velocity)
				splatters[i].process_material.initial_velocity_max += raycasts[i].get_collision_normal().dot(entity.velocity)
			else:
				splatters[i].draw_pass_1.surface_get_material(0).albedo_color = Color.DARK_SLATE_GRAY
			splatters[i].restart()
	
	if recoil_tween:
		recoil_tween.kill()
	if gun_tween:
		gun_tween.kill()
	recoil_tween = create_tween()
	gun_tween = create_tween()
	recoil += 0.1
	recoil_tween.tween_property(self, "recoil", 0.0, 0.07)
	gun_graphics.position.z = -0.063
	gun_tween.tween_property(gun_graphics, "position:z", -0.163, 0.2)
	
	velocity += 2.0 * camera.get_global_transform().basis.z
	
	gun_sfx.pitch_scale = randf_range(0.9, 1.1)
	gun_sfx.play()
	
	ammo -= 1
	if ammo <= 0:
		reload_gun()

func reload_gun():
	var reload_tween = create_tween()
	reload_tween.tween_property(gun_graphics, "position:y", -0.35, reload_wait.wait_time/2.0)
	reload_tween.tween_property(gun_graphics, "position:y", -0.107, reload_wait.wait_time/2.0)
	reload_wait.start()
	reload_sfx.play()

func _on_footstep_timer_timeout():
	can_step = true

func _on_muzzle_flash_timer_timeout() -> void:
	muzzle_flash.light_energy = 0.0

func _on_reload_wait_timeout() -> void:
	ammo = AMMO_MAX
