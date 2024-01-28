extends AudioStreamPlayer

@export var intro_stream: AudioStreamOggVorbis
@export var loop_stream: AudioStreamOggVorbis

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished", _on_finished)
	
	if intro_stream != null:
		self.stream = intro_stream
		self.play(0.0)
	else:
		skip()
	
func _on_finished():
	skip()

func skip():
	self.stream = loop_stream
	loop_stream.loop = true
	self.play(0.0)
	self.disconnect("finished", _on_finished)
