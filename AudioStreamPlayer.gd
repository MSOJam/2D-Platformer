extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.playing == false:
		self.playing = true
