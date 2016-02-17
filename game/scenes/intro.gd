extends Node2D

var main = preload("res://scenes/main.scn")
var current_game = false
var new_game
var exit
var buttons
var game_node
var fullscreen
var ui
var title
var full = false


func _ready():
	var root = get_node("/root")
	game_node = get_node("Game")
	ui = get_node("UI")
	buttons = get_node("UI/Buttons")
	new_game = get_node("UI/Buttons/NewGame")
	fullscreen = get_node("UI/Buttons/FullScreen")
	exit = get_node("UI/Buttons/Exit")
	title = get_node("UI/Title")
	fullscreen.connect("pressed", self, "_on_FullScreen_pressed")
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
			ui.show()
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
	ui.hide()
	new_game.set_text("Continue")
	
func _on_FullScreen_pressed():
	if full:
		OS.set_window_fullscreen(false)
		fullscreen.set_text("Full screen")
		full = false
	else:
		OS.set_window_fullscreen(true)
		fullscreen.set_text("Windowed")
		full = true
