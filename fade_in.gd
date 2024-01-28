extends Control

@export var fade_time: float = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.modulate
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($ColorRect, "modulate", Color.TRANSPARENT, fade_time)
	tween.tween_callback(_done)

func _done():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
