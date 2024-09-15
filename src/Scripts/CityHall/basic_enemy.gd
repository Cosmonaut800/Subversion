extends CharacterBody3D

@export var player: CharacterBody3D
@export var speed := 7.0

@onready var graphics := $Graphics
@onready var nav_agent := $NavigationAgent3D
@onready var hitbox := $CollisionShape3D
@onready var hurtbox := $Hurtbox
@onready var attack_cooldown := $AttackCooldown
@onready var damage_timer := $DamageTimer
@onready var death_timer := $DeathTimer
@onready var death_particles := $DeathParticles
@onready var anim_tree := $AnimationTree

var health := 100.0
var state = STATE.TRACKING
var parent_spawner: Node3D = null

enum STATE {TRACKING, ATTACKING, DEAD}

func _process(_delta):
	if Vector3(velocity.x, 0.0, velocity.z).length() > 0.0:
		basis = basis.looking_at(-Vector3(velocity.x, 0.0, velocity.z))
	
	if hurtbox.has_overlapping_bodies() and attack_cooldown.is_stopped():
		attack()

func _physics_process(_delta: float) -> void:
	nav_agent.set_target_position(player.position)
	velocity = speed * (nav_agent.get_next_path_position() - global_position).normalized()
	
	if health < 0.0 and death_timer.is_stopped():
		die()
	
	if state == STATE.TRACKING:
		move_and_slide()

func die():
	if parent_spawner:
		parent_spawner.enemies.erase(self)
	state = STATE.DEAD
	graphics.set_visible(false)
	hitbox.disabled = true
	death_particles.restart()
	death_timer.start()

func attack():
	state = STATE.ATTACKING
	anim_tree.set("parameters/conditions/attack", true)
	anim_tree.set("parameters/conditions/chase", false)
	attack_cooldown.start()
	damage_timer.start()

func _on_death_timer_timeout() -> void:
	queue_free()

func _on_attack_cooldown_timeout() -> void:
	if state == STATE.ATTACKING:
		state = STATE.TRACKING
		anim_tree.set("parameters/conditions/attack", false)
		anim_tree.set("parameters/conditions/chase", true)

func _on_damage_timer_timeout() -> void:
	if hurtbox.has_overlapping_bodies() and state == STATE.ATTACKING:
		player.health -= 10.0
