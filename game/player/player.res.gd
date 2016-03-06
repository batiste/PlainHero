extends Node2D

var animations
var weapon

func _ready():
	animations = get_node("animations/AnimationPlayer")
	weapon = get_node("animations/weapon")
	
func change_weapon():
	var hammer = ResourceLoader.load("misc/weapons/dummy-hammer2")
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
		
	#var anim = animations.get_animation(anim_name)
	
	#animations.set_current_animation(anim_name)
	animations.play(anim_name)
	