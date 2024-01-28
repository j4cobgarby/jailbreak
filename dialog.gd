extends Control

@export_multiline var text : String = ""

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

	update_label()

func _ready():
	visible = false
	
func _input(event):
	if not visible:
		return
		
	if Input.is_action_just_pressed("enter"):
		page_n += 1
		if page_n >= num_pages:
			visible = false
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
	$lbl.text = pages[page_n]
