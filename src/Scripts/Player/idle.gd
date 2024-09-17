extends State

@export var move_state: State
@export var interact_state: State #this will need to handle either dialogue or starting of flyswatting game - which will probably begin at the end of a dialogue
@onready var dialogue_starter_detector := $"../../Character/DialogueStarterDetector"
@export var dialogue_resource : DialogueResource
@onready var anim_tree := $"../../AnimationTree"
@onready var camera := $"../../CameraPivot/Camera3D"
@onready var camera_pivot := $"../../CameraPivot"
@onready var dialogue_point := $"../../DialoguePoint"
var dialogue_start := "this_is_a_node_title"
var can_move : bool = true
var entity_to_rotate: Node3D = null
var start_rotation = false


func enter() -> void:
	dialogue_starter_detector.monitoring = true
	#parent.animation_player.play(animation_name)
	anim_tree.set("parameters/conditions/stop", true)
	anim_tree.set("parameters/conditions/run", false)
	parent.velocity.x = 0
	parent.velocity.z = 0
	Global.player_can_move = true

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	var key_pressed : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	if Global.player_can_move:
		if key_pressed.x != 0 || key_pressed.y != 0:
			return move_state
	if Input.is_action_just_pressed("interact"):
		move_camera_to_dialogue_pos()
		var dialogue_starters = dialogue_starter_detector.get_overlapping_areas()
		if dialogue_starters.size() > 0:
			Global.is_talking = true
			entity_to_rotate = dialogue_starters[0]
			entity_to_rotate.start_dialogue()
			return 
	if Global.is_talking:
		return interact_state
	else:
		if Global.is_talking == false:
			move_camera_to_original_post()
	return null

func process_physics(_delta: float) -> State:
	if not parent.is_on_floor():
		parent.velocity.y -= 50 * _delta
	else:
		parent.velocity.y = 0
	#if Global.is_talking:
		#rotate_entity_smoothly(entity_to_rotate.get_parent(), _delta)
	parent.move_and_slide()
	return null

func rotate_entity_smoothly(entity: Node3D, delta: float) -> void:
	# Calculate the direction vector from the entity to the player
	var direction_to_player = (parent.global_transform.origin - entity.global_transform.origin).normalized()
	# Calculate the target rotation basis for the entity to face the player
	var target_rotation = Basis().looking_at(direction_to_player, Vector3.UP)
	# Smoothly interpolate the entity's current basis towards the target rotation
	entity.transform.basis = entity.transform.basis.slerp(target_rotation, 8 * delta)

func move_camera_to_dialogue_pos():
		get_tree().create_tween().tween_property(camera, "position:z", dialogue_point.position.z,0.2)
		get_tree().create_tween().tween_property(camera, "position:y", dialogue_point.position.y,0.2)

func move_camera_to_original_post():
		get_tree().create_tween().tween_property(camera, "position:z", camera_pivot.position.z,0.2)
		get_tree().create_tween().tween_property(camera, "position:y", camera_pivot.position.y,0.2)
	
