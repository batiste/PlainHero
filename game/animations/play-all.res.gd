 extends AnimatedSprite

var tempElapsed = 0
var nbFrames = 0
var currentFrame = 0
export var canBeInterrupted = true

func _ready():
   set_process(true)
   nbFrames = self.get_sprite_frames().get_frame_count()
   
func _process(delta):
   tempElapsed = tempElapsed + delta
   
   if(tempElapsed > 0.1):
      if(get_frame() == nbFrames - 1):
         set_frame(0)
      else:
         self.set_frame(get_frame() + 1)
      
      tempElapsed = 0

func canInterrupt():
	if(get_frame() == 0 or canBeInterrupted):
		return true
	return false