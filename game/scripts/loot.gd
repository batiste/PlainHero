tool
extends Sprite

var types = [
	"helmet",
	"helmet",
	"sword"
]

var materials = [
	"leather",
	"iron",
	"dragon scale"
]

export(String) var name
var power
export(String, "helmet", "boots", "armor", "sword") var type 
var material

func _ready():
	type = types[randi() % types.size()]
	material = materials[randi() % materials.size()]
	name = type + " of " + material
	power = rand_range(2, 8)


