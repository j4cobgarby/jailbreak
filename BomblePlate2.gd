extends Node3D

var rot_speed: float = 0.0
var bounce: float = 0.0
var time: float = 0.0

@export var next_scene : String

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rot_speed", 12.0, 0.5)
	tween.tween_property(self, "rot_speed", 1.5, 3)
	
	var tween2 = get_tree().create_tween()
	tween2.set_trans(Tween.TRANS_LINEAR)
	tween2.tween_property(self, "bounce", 0.35, 0.5)
	tween2.tween_property(self, "bounce", 0, 0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	rotate(Vector3(0,1,0), delta * rot_speed)
	scale.y = 1 + bounce * sin(time * 5)

func _on_timer_timeout():
	get_tree().change_scene_to_file(next_scene)
