extends Control

# proper paragraph time: 8.629

@export var paragraphs = [
	"The year is 2026.",
	"In the shadows of a dystopian world, where budget constraints have forced the government's hand, they turn to artificial intelligence to maintain control within prison walls.",
	"As a master of the digital realm, your expertise lies in the art of hacking; and now, you see an opportunity. The government's attempt to save money has inadvertently given you the keys to a new kingdom.",
	"Harness your silver tongue to manipulate artificial minds; convince the robots to dance to your tune, exploiting their weaknesses, and turning their cold logic into a weapon.",
	"JAILBREAK"
]

@export var paragraph_scene: PackedScene

@export var game_scene: PackedScene

var i = 0
var time = 0.0
var fade_time = 3.59541667 * 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if i < len(paragraphs):
		$Background.modulate = Color.BLACK.lerp(Color.DIM_GRAY, time / 18.0)
	else:
		$Background.position.y += 50 * delta
		$FadeOverlay.modulate.a += delta / fade_time


func _paragraph_timer_tick():
	if i < len(paragraphs):
		show_paragraph()
	else:
		start_game()

func show_paragraph():
	var paragraph = paragraphs[i]
		
	var para_instance = paragraph_scene.instantiate()
	para_instance.text = paragraph
	$Paragraphs.add_child(para_instance)
	
	#var lab = Label.new()
	#lab.modulate
		
	if i + 1 == len(paragraphs):
		para_instance.label_settings = para_instance.label_settings.duplicate()
		para_instance.label_settings.font_color = Color.RED
		para_instance.label_settings.font_size = 40
		para_instance.z_index = 5
		$Background.modulate = Color.DARK_RED
		$ParagraphTimer.start(3.59541667 * 4)
		fade_audio()
		
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(para_instance.label_settings, "font_size", 300, fade_time * 0.8)
		tween.tween_property($Paragraphs, "anchor_top", -2, fade_time * 0.9)
		tween.tween_property(para_instance, "modulate", Color.TRANSPARENT, fade_time * 0.2)
		
	i += 1

func start_game():
	get_tree().change_scene_to_packed(game_scene)

func skip():
	while i < len(paragraphs):
		show_paragraph()
	
	$ParagraphTimer.start(3.59541667)
	fade_time = 3.59541667
	$AudioPlayer.skip()
	fade_audio()

func fade_audio():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property($AudioPlayer, "volume_db", -80, fade_time)
	tween.tween_property($AudioPlayer, "pitch_scale", 4, fade_time)

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE:
		skip()
