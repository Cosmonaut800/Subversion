extends Node3D

@onready var pivot = $Pivot
@onready var pickup_sfx: AudioStreamPlayer3D = $PickupSFX
@onready var timer: Timer = $Timer
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

signal picked_up

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pivot.basis = pivot.basis.rotated(Vector3.UP, PI * delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	picked_up.emit()
	pivot.set_visible(false)
	omni_light_3d.light_energy = 0
	pickup_sfx.play()
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
