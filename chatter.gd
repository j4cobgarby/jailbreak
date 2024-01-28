extends AudioStreamPlayer

@export var streams = [
	load("res://low/low-01.ogg"),
	load("res://low/low-02.ogg"),
	load("res://low/low-03.ogg"),
	load("res://low/low-04.ogg"),
	load("res://low/low-05.ogg"),
	load("res://low/low-06.ogg"),
	load("res://low/low-07.ogg"),
]

@export var pause_chance: float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream = streams.pick_random()
	self.connect("finished", _on_finished)
	self.play()
	
	$PauseTimer.connect("timeout", _timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_finished():
	if randf() < pause_chance:
		$PauseTimer.start()
	else:
		next_phoneme()

func next_phoneme():
	self.stream = streams.pick_random()
	self.pitch_scale = randf_range(0.9, 1.1)
	self.play()
	
func _timeout():
	next_phoneme()
