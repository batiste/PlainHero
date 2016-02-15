extends Node2D

var walkUp
var idleFront
var walkDown

var animations = {}

func _ready():
	animations["walk-up"] = get_node("walk-up")
	animations["walk-down"] = get_node("walk-down")
	animations["idle-front"] = get_node("idle-front")
	hideAll()
	
func hideAll():
	for key in animations:
		animations[key].hide()
	
func update_direction(direction):
	var anim_name = "idle-front"
	if direction.y > 0:
		anim_name = "walk-down"
	if direction.y < 0:
		anim_name = "walk-up"
	
	hideAll()
	var anim = animations[anim_name]
	anim.set_pos(Vector2(-17, -53))
	anim.show()
	