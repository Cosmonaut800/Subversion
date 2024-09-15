extends Area3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
@export var game_name : String

signal minigame1_started
signal minigame2_started
signal fps_started

func start_dialogue() -> void:
	Global.is_talking = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	
	if game_name != null:
		if game_name == "game one" and not Global.game_one_completed and not Global.game_two_completed:
			Global.game_one_completed = true
			Global.player_can_move = false
			minigame1_started.emit()
		if game_name == "game two" and Global.game_one_completed and not Global.game_two_completed and Global.tobin_found:
			Global.game_two_completed = true
			Global.player_can_move = false
			minigame2_started.emit()
		if game_name == "game three" and Global.game_one_completed and Global.game_two_completed:
			fps_started.emit()
		if game_name == "tobin" and Global.game_one_completed and not Global.game_two_completed:
			Global.tobin_found = true
	
