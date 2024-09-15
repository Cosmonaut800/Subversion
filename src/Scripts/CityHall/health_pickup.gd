extends Node3D

@export var heal_amount := 50.0

@onready var pivot := $Pivot
@onready var pickup_sfx: AudioStreamPlayer3D = $PickupSFX
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var timer: Timer = $Timer

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.health += 50.0
	pivot.set_visible(false)
	omni_light_3d.light_energy = 0
	pickup_sfx.play()
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()


func _process(delta):
	pivot.basis = pivot.basis.rotated(Vector3.UP, 1.5 * delta)
