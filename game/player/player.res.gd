extends Node2D

var walkUp
var idleFront
var walkDown

var animations = {}
var currentAnimation

func _ready():
	currentAnimation = get_node("idle-front")
	
	animations["walk-back"] = get_node("walk-up")
	animations["walk-front"] = get_node("walk-down")
	animations["walk-left"] = get_node("walk-left")
	animations["walk-right"] = get_node("walk-right")
	
	animations["attack-left"] = get_node("attack-left")
	animations["attack-right"] = get_node("attack-right")
	animations["attack-front"] = get_node("attack-front")
	animations["attack-back"] = get_node("attack-back")
	
	animations["idle-front"] = get_node("idle-front")
	animations["idle-left"] = get_node("idle-front")
	animations["idle-right"] = get_node("idle-front")
	animations["idle-back"] = get_node("idle-front")
	
	var node = get_node("walk-up")
	
	hideAll()
	
func hideAll():
	for key in animations:
		animations[key].hide()
	
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
	#if not currentAnimation.canInterrupt():
	#	return false
	hideAll()
	var anim = animations[anim_name]
	if currentAnimation != anim:
		var player = anim.get_node("AnimationPlayer")
		if player:
			player.seek(0)
		
	currentAnimation = anim
	anim.set_pos(Vector2(-17, -53))
	anim.show()
	