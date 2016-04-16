
extends KinematicBody2D

var velocity = Vector2(0, 0)
var normal_velocity = 300
var elapsed = 0
var health = 10
var label
var root
var npc
var anim
var state = "idle"
var animations
var destroyed_by

func _ready():
	set_fixed_process(true)
	label = get_node("Label")
	label.set_text(str(health))
	root = get_tree().get_root()
	var intro = root.get_node("intro")
	npc = intro.get_node("Game/game/npc")
	anim = get_node("AnimationPlayer")
	animations = get_node("animations/AnimationPlayer")

var next_to_be_played = "idle"

func land():
	next_to_be_played = "idle"
	velocity = Vector2(0, 0)

func destroy():
	if(destroyed_by and destroyed_by.has_method("increase_xp")):
		print("Increse XP")
		destroyed_by.increase_xp(2)
	npc.remove_child(self)


func jump():
	var direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()
	velocity = normal_velocity * direction

var attack_speed = normal_velocity * 2

func attack_left():
	var direction = Vector2(-0.5, randf() - 0.5).normalized()
	velocity = attack_speed * direction
	
func attack_right():
	var direction = Vector2(0.5, randf() - 0.5).normalized()
	velocity = attack_speed * direction
	
func bored():
	if randf() < 0.04:
		next_to_be_played = "attack-left"
		return
	if randf() < 0.04:
		next_to_be_played = "attack-right"
		return
	if randf() < 0.2:
		next_to_be_played = "move"
		return

		
func _fixed_process(delta):
	move(velocity * delta)
	elapsed += delta
	
	if is_colliding():
		if velocity.length() > normal_velocity:
			var body = get_collider()
			if(body.has_method("take_damage")):
				body.take_damage(1, self)
		revert_motion()
		velocity = - velocity / 2
	else:
		velocity = velocity / 1.2
		
	var anim_name = animations.get_current_animation()
	if anim_name != next_to_be_played and anim_name != "death":
		animations.play(next_to_be_played)

func take_damage(v, from):
	if(health < 1):
		return
	
	get_node("SamplePlayer2D").play("squish2")
	health = health - 1
		
	label.set_text(str(v))
	next_to_be_played = "take-damage"
	anim.play("damage")
	var v = from.get_pos()
	v += Vector2(0, -10)
	var vect =  get_pos() - v
	velocity = vect.normalized() * 2 * normal_velocity

	if(health < 1):
		next_to_be_played = "death"
		animations.play(next_to_be_played)
		get_node("SamplePlayer2D").play("explode")
		velocity = velocity / 1.5
		destroyed_by = from
	
func hurt_when_touched(to):
	to.take_damage(1, self)
	