
extends Node

func _ready():
	pass

func take_damage(v, from):
	self.get_parent().take_damage(v, from)

