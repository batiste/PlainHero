extends Node2D

var animations
var weapon
var hitbox

func _ready():
	animations = get_node("animations/AnimationPlayer")
	weapon = get_node("animations/weapon")
	#change_weapon()
	hitbox = get_node("animations/hitbox")
	#set_process(true)
	
func _process(delta):
	pass
	
func hit():
	print("hit")
	if(hitbox.is_colliding()):
		print("boum")
	
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
	