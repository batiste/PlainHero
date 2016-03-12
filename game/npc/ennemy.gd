
extends KinematicBody2D

var velocity = Vector2(0, 0)
var normal_velocity = 100
var elapsed = 0
var health = 10
var label
var root
var game
var anim

func _ready():
	set_fixed_process(true)
	label = get_node("Label")
	label.set_text(str(health))
	root = get_tree().get_root()
	var intro = root.get_node("intro")
	game = intro.get_node("Game")
	game = game.get_children()[0]
	anim = get_node("AnimationPlayer")

func _fixed_process(delta):
	move(velocity * delta)
	elapsed += delta
	
	if is_colliding():
		if velocity.length() > normal_velocity:
			var body = get_collider()
			if(body.has_method("take_damage")):
				body.take_damage(2, self)
		revert_motion()
		velocity = - velocity / 2
		
	var v = normal_velocity / 4.0 * Vector2(randf() - 0.5, randf() - 0.5)
	velocity = velocity + v
	
	if velocity.length() > normal_velocity:
		velocity = velocity / 1.1
	elif int(elapsed) % 5 == 0:
		velocity = velocity / 1.2

func take_damage(v, from):
	health = health - 1
	if(health < 1):
		game.remove_child(self)
		return
	print("take-damage ", v, from)
	label.set_text(str(v))
	anim.play("damage")
	var v = from.get_pos()
	v += Vector2(0, -10)
	var vect =  get_pos() - v
	print(vect, vect.normalized())
	velocity = vect.normalized() * 4 * normal_velocity