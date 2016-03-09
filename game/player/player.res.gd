extends Node2D

var animations
var weapon
var weaponbox
var weapon_damage = 2
var collectbox

func _ready():
	animations = get_node("animations/AnimationPlayer")
	weapon = get_node("animations/weapon")
	#change_weapon()
	weaponbox = get_node("weaponbox")
	collectbox = get_node("collectbox")
	set_process(true)
	
func _process(delta):
	for body in collectbox.get_overlapping_bodies():
		if(body.has_method("collect")):
			body.collect()
		
	
func hit():
	for body in weaponbox.get_overlapping_bodies():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)
	for body in weaponbox.get_overlapping_areas():
		if(body.has_method("take_damage")):
			body.take_damage(weapon_damage, self)
	
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
	update('idle-front')
	
func update(anim_name):
	
	var current = animations.get_current_animation()
	if current.basename() == anim_name:
		return
		
	animations.play(anim_name)
	