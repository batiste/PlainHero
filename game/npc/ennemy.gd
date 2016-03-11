
#extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var velocity = Vector2(0, 0)
var normal_velocity = 100
var elapsed = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	move(velocity * delta)
	elapsed += delta
	
	if is_colliding():
		revert_motion()
		velocity = - velocity / 2
		
	var v = normal_velocity / 4.0 * Vector2(randf() - 0.5, randf() - 0.5)
	velocity = velocity + v
	
	if velocity.length() > normal_velocity:
		velocity = velocity / 1.1
	elif int(elapsed) % 10 == 0:
		velocity = velocity / 1.2

func take_damage(v, from):
	print("take-damage ", v, from)
	var v = from.get_pos()
	v += Vector2(0, -10)
	var vect =  get_pos() - v
	print(vect, vect.normalized())
	velocity = vect.normalized() * 4 * normal_velocity