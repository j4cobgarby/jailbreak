extends VBoxContainer

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	self.offset_left = sin(time * 4.7) * 80
	self.offset_top = sin(time * 3.45) * 80
