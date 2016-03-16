extends KinematicBody2D

var animations
var weapon
var weaponbox
var weapon_damage = 3
var collectbox
var facing_direction = Vector2(0, 1)
var pos
var health = 100
var healthBar
var anim

func _ready():
	animations = get_node("animations/AnimationPlayer")
	weapon = get_node("animations/weapon")
	weaponbox = get_node("weaponbox")
	collectbox = get_node("collectbox")
	set_fixed_process(true)

	var root = get_tree().get_root()
	var intro = root.get_node("intro")
	
	healthBar = intro.get_node("Game/game/Health/VBoxContainer/ProgressBar")
	anim = get_node("AnimationPlayer")
	
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
	
	var speed = 180
	
	var motion = direction * speed * delta
	move(motion)
	
	if is_colliding():
		revert_motion()
		var collider = get_collider()
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

func hit():
	
	for body in weaponbox.get_overlapping_bodies():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)
	for body in weaponbox.get_overlapping_areas():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)

func take_damage(v, from):
	if from == self:
		return
	health = health - v
	get_node("health").set_text(str(v))
	get_node("AnimationPlayer").play("damage")
	healthBar.set_value(health)

func change_weapon():
	var hammer = ResourceLoader.load("misc/weapons/dummy-hammer2.tex")
	weapon.set_texture(hammer)
	
func get_anim_direction(direction):
	if direction.x < 0:
		return "left"
	if direction.x > 0:
		return "right"
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
	if current.basename() == anim_name:
		return
		
	animations.play(anim_name)
	