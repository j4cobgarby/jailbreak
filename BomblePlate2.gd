extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(Vector3(0,1,0), delta)


func _on_timer_timeout():
	print("Hello World")
	pass # Replace with function body.
