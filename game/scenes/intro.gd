extends Node2D

var main = preload("res://scenes/main.scn")
var current_game = false
var new_game
var exit
var buttons
var game_node

func _ready():
	var root = get_node("/root")
	game_node = get_node("Game")
	new_game = get_node("Buttons/NewGame")
	buttons = get_node("Buttons")
	exit = get_node("Buttons/Exit")
	new_game.connect("pressed", self, "_on_NewGame_pressed")
	exit.connect("pressed", self, "_on_Exit_pressed")
	
	set_process_input(true)
	set_process(true)
	
#Input handler, listen for ESC to exit app
func _input(event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		if(current_game):
			current_game.get_tree().set_pause(true)
			buttons.show()
			exit.set_process_input(true)
			get_node("Title").show()
		else:
			get_tree().quit()

func _on_Exit_pressed():
	get_tree().quit()

func _on_NewGame_pressed():
	if not current_game:
		current_game = main.instance()
		game_node.add_child(current_game)
	else:
		current_game.get_tree().set_pause(false)
	buttons.hide()
	get_node("Title").hide()
	new_game.set_text("Continue")
