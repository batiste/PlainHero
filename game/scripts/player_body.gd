extends KinematicBody2D

func _ready():
   set_process(true)
   
func _process(delta):
	if is_colliding():
		print("COLLIIIIIIDFES")