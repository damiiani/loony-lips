extends Control

onready var PlayerText := $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText := $VBoxContainer/DisplayText
onready var ConfirmButton := $VBoxContainer/HBoxContainer/ConfirmButton
onready var ButtonLabel := $VBoxContainer/HBoxContainer/ButtonLabel

var current_story: Dictionary
var player_words: Array


func _on_PlayerText_text_entered(_new_text: String) -> void:
	add_to_player_words()


func _on_TextureButton_pressed() -> void:
	if is_story_done():
		var err := get_tree().reload_current_scene()

		if err:
			print("Erro")

		return

	add_to_player_words()


func _ready() -> void:
	set_current_story()
	introduction()

	PlayerText.grab_focus()

	check_player_words_lenght()


func set_current_story() -> void:
	randomize()

	var stories := get_from_json("res://src/scripts/StoryBook.json")

	current_story = stories[randi() % stories.size()]


func get_from_json(path) -> Dictionary:
	var file := File.new()

	file.open(path, File.READ)

	var text = file.get_as_text()
	var data = parse_json(text)

	file.close()

	return data


func introduction() -> void:
	DisplayText.text = "Bem vindo ao Loony Lips, um jogo de texto FODASTICO MERMAO\n\n"


func add_to_player_words() -> void:
	player_words.append(PlayerText.text)

	PlayerText.clear()
	DisplayText.text = ""

	check_player_words_lenght()


func check_player_words_lenght() -> void:
	if is_story_done():
		end_game()
	else:
		prompt_player()


func is_story_done() -> bool:
	return player_words.size() == current_story.prompts.size()


func prompt_player() -> void:
	var prompt: String = current_story.prompts[player_words.size()]

	DisplayText.text += prompt


func end_game() -> void:
	PlayerText.queue_free()
	ButtonLabel.text = "Novamente?"
	tell_story()


func tell_story() -> void:
	DisplayText.text = current_story.story % player_words
