extends AudioStreamPlayer

var streams = []

@export var pause_chance: float = 0.3

var should_stop = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished", _on_finished)
	
	$PauseTimer.connect("timeout", _timeout)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			stop_when_available()
		elif event.keycode == KEY_ENTER:
			start_chatter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_finished():
	if randf() < pause_chance:
		$PauseTimer.start()
	elif not should_stop:
		next_phoneme()

func next_phoneme():
	self.stream = streams.pick_random()
	self.pitch_scale = randf_range(0.9, 1.1)
	self.play()

func _timeout():
	next_phoneme()

func start_chatter():
	should_stop = false
	self.stream = streams.pick_random()
	self.play(0.0)

func stop_when_available():
	should_stop = true
