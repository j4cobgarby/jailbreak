extends Control

@export var next_scene = ""
@export var icon_num : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var icons = [
	"res://lunch.png",
	"res://robot.png",
	"res://zaz.jpg"
]

func trim_strings(strings, max):
	var news = []
	for s in strings:
		var words = Array(s.split(" "))
		var current_line = ""
		
		while len(words) > 0:
			var w = words.pop_front()
			if len(current_line) + len(w) > max:
				news.append(current_line)
				if len(w) < max:
					current_line = w + " "
				else:
					news.append(w)
					current_line = ""
			else:
				current_line += w + " "
		news.append(current_line)
	return news

func _on_conversation_system_got_response(resp):
	var lines = "\n".join(trim_strings(resp.split("\n"), 50))
	$dialog.freeze_run(lines, icons[icon_num])

func _on_conversation_system_succeeded(resp):
	var lines = "\n".join(trim_strings(resp.split("\n"), 50))
	$dialog.freeze_run(lines, icons[icon_num], next_scene)

func _on_conversation_system_user_typing(typing):
	if typing:
		$SubViewportContainer/SubViewport/world/player.frozen = true
	else:
		$SubViewportContainer/SubViewport/world/player.frozen = false


func _on_conversation_system_thinking():
	print("Thinking")
	$dialog.freeze_run("Hello\nWorld", icons[icon_num])
