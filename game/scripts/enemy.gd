
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass

var direction = Vector2(randf(), randf()).normalized()
	
func _process(delta):
	var speed = 60
	var motion = direction * speed * delta
	var previous_pos = get_pos()
	set_pos(previous_pos + motion)
	
	
	


