extends Area3D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
@export var game_name : String


func start_dialogue() -> void:
	Global.is_talking = true
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	
	if game_name != null:
		if game_name == "game one" and not Global.game_one_completed and not Global.game_two_completed:
			Global.game_one_completed = true
			print(Global.game_one_completed)
		if game_name == "game two" and Global.game_one_completed and not Global.game_two_completed:
			Global.game_two_completed = true
			print(Global.game_two_completed)
		if game_name == "game three" and Global.game_one_completed and Global.game_two_completed:
			print("Game three has started!")
		if game_name == "tobin" and Global.game_one_completed and not Global.game_two_completed:
			Global.tobin_found = true
	
