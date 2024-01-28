extends Control

@export_multiline var text : String = ""

@export var stream_urls = [
	"res://robot/robot-01.ogg",
	"res://robot/robot-02.ogg",
	"res://robot/robot-03.ogg",
	"res://robot/robot-04.ogg",
	"res://robot/robot-05.ogg",
	"res://robot/robot-06.ogg",
	"res://robot/robot-07.ogg",
	"res://robot/robot-08.ogg",
	"res://robot/robot-09.ogg",
	"res://robot/robot-10.ogg",
	"res://robot/robot-11.ogg",
	"res://robot/robot-12.ogg",
	"res://robot/robot-13.ogg"
]

var PAGE_LINES = 4

var lines : Array
var page_n : int
var pages : Array
var num_pages : int
var next_scene = null

func pg(x): # Number of pages for x lines
	return 1 + (floor((x - 1) / PAGE_LINES))

func reset():
	visible = true
	lines = text.split("\n")
	page_n = 0
	num_pages = pg(len(lines))
	var final_page_lines = len(lines) % PAGE_LINES
	
	if final_page_lines == 0:
		final_page_lines = PAGE_LINES
	
	pages.clear()
	for i in range(num_pages):
		pages.append("\n".join(lines.slice(i * PAGE_LINES, (i + 1) * PAGE_LINES)))

	$Chatter.start_chatter()
	update_label()

func _ready():
	for url in stream_urls:
		print(url)
		$Chatter.streams.append(load(url))
		
	visible = false
	
func _input(event):
	if not visible:
		return
		
	if Input.is_action_just_pressed("enter"):
		page_n += 1
		if page_n >= num_pages:
			visible = false
			print(str(page_n) + ", " + str(num_pages))
			$Chatter.stop_when_available()
			if next_scene != null:
				get_tree().change_scene_to_file(next_scene)
			return
		else:
			update_label()
			
func freeze_run(txt, icon_path, nxt=null):
	next_scene = nxt
	text = txt
	var new_img = Image.new()
	new_img.load(icon_path)
	$image.texture = ImageTexture.new().create_from_image(new_img)
	reset()

func update_label():
	print("update label")

	$lbl.text = pages[page_n]
