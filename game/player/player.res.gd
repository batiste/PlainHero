extends KinematicBody2D

var animations
var weapon
var weaponbox
var weapon_damage = 3
var collectbox
var facing_direction = Vector2(0, 1)
var pos
var health = 20
var max_health = 20
var health_bar
var xp = 0
var max_xp = 100
var xp_bar

var anim
var max_speed = 2.0
var acc = 10

var velocity = Vector2(0, 0)

func _ready():
	animations = get_node("animations/AnimationPlayer")
	weapon = get_node("animations/weapon")
	weaponbox = get_node("weaponbox")
	collectbox = get_node("collectbox")
	set_fixed_process(true)

	var root = get_tree().get_root()
	var intro = root.get_node("intro")
	
	health_bar = intro.get_node("Game/game/Health/VBoxContainer/Health")
	health_bar.set_value(health)
	health_bar.set_max(max_health)
	
	xp_bar = intro.get_node("Game/game/Health/VBoxContainer/XP")
	xp_bar.set_value(xp)
	xp_bar.set_max(max_xp)
	
	anim = get_node("AnimationPlayer")
	
func increase_xp(v):
	xp = xp + v
	print(xp)
	xp_bar.set_value(xp)
	xp_bar.set_max(100)
	
func _fixed_process(delta):
	for body in collectbox.get_overlapping_bodies():
		if(body.has_method("collect")):
			body.collect()
	
	var direction = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		direction = direction + Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		direction = direction + Vector2(1, 0)
	if Input.is_action_pressed("ui_up"):
		direction = direction + Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		direction = direction + Vector2(0, 1)
	
	direction = direction.normalized()
	
	if direction != Vector2(0, 0):
		facing_direction = direction
	else:
		velocity = velocity / 1.5
	
	var acc = 15
	
	#if direction.x < 0 and velocity.x > 0:
	#	velocity.x = 0
	#if direction.x > 0 and velocity.x < 0:
	#	velocity.x = 0
	#if direction.y < 0 and velocity.y > 0:
	#	velocity.y = 0
	#if direction.y > 0 and velocity.y < 0:
	#	velocity.y = 0
	
	velocity += direction * acc * delta
	if velocity.length() > max_speed:
		velocity = velocity / 1.1
	
	var motion = velocity
	var speed = motion.length()
	move(motion)
	
	if is_colliding():
		velocity = Vector2(0, 0)
		revert_motion()
		var collider = get_collider()
		if(collider.has_method("hurt_when_touched")):
			collider.hurt_when_touched(self)
			repulse(collider)
		var n = get_collision_normal()
		var slide = n.slide(direction).normalized() * speed * delta
		move(slide)
	
	pos = get_pos()
	
	if Input.is_action_pressed("ui_accept"):
		update_attack(facing_direction)
	elif direction == Vector2(0, 0):
		update_idle(facing_direction)
	else:
		update_walk(facing_direction)

func repulse(from):
	var v = from.get_pos()
	var vect =  get_pos() - v
	velocity += vect.normalized() * 3

func hit():
	
	for body in weaponbox.get_overlapping_bodies():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)
	for body in weaponbox.get_overlapping_areas():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)
			
func swish():
	get_node("SamplePlayer2D").play("swish")

func take_damage(v, from):
	if from == self:
		return
	repulse(from)
	health = health - v
	get_node("AnimationPlayer").play("damage")
	health_bar.set_value(health)
	#change_weapon()

func change_weapon():
	var hammer = ResourceLoader.load("misc/weapons/dummy-hammer2.tex")
	weapon.set_texture(hammer)
	
func get_anim_direction(direction):
	if(abs(direction.x) >= abs(direction.y)):
		if direction.x < 0:
			return "left"
		if direction.x > 0:
			return "right"
	else:
		if direction.y > 0:
			return "front"
		if direction.y < 0:
			return "back"
	return "front"
	
func update_attack(direction):
	update('attack-' + get_anim_direction(direction))
	
func update_walk(direction):
	update('walk-' + get_anim_direction(direction))

func update_idle(direction):
	update('idle-' + get_anim_direction(direction))
	
func update(anim_name):
	
	var current = animations.get_current_animation()
	if current.substr(0, 3) == "att" and animations.is_playing():
		return
	
	if animations.is_playing() and current.basename() == anim_name:
		return
	
	animations.play(anim_name)
	