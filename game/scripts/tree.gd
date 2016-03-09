
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func take_damage(v, from):
	print("take-damage ", v, from)
	var parent = self.get_parent()
	parent.get_parent().remove_child(parent)

