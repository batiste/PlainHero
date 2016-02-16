extends Node2D

var main = preload("res://scenes/main.scn")
var current_game = false
var new_game
var exit
var buttons
var game_node
var ui
var title

func _ready():
	var root = get_node("/root")
	game_node = get_node("Game")
	ui = get_node("UI")
	buttons = get_node("UI/Buttons")
	new_game = get_node("UI/Buttons/NewGame")
	exit = get_node("UI/Buttons/Exit")
	title = get_node("UI/Title")
	new_game.connect("pressed", self, "_on_NewGame_pressed")
	exit.connect("pressed", self, "_on_Exit_pressed")
	
	set_process_input(true)
	set_process(true)
	
#Input handler, listen for ESC to exit app
func _input(event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		if(current_game):
			current_game.get_tree().set_pause(true)
			current_game.set_opacity(0.5)
			buttons.show()
			exit.set_process_input(true)
			title.show()
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
		current_game.set_opacity(1.0)
	buttons.hide()
	title.hide()
	new_game.set_text("Continue")
