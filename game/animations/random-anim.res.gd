extends AnimatedSprite

var tempElapsed = 0

func _ready():
   set_process(true)
   
func _process(delta):
	tempElapsed = tempElapsed + delta
	if(tempElapsed > 0.05):
		var nb_frames = self.get_sprite_frames().get_frame_count()
		self.set_frame((randi() % nb_frames))
		tempElapsed = 0

