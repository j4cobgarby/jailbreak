extends Label

var full_names = {
	"bombles": "Tray of 'bombles'",
	"slop": "Tray of slop",
	"celldoor": "Cell Door"
}

var vis = {}

var descs = {
	"bombles": "How intriguing! Those things look pretty tasty,\nbut the chef hates handing them out for some reason!\nI gotta convince him to let me have some.",
	"slop": "Man, that looks gross! There's no way I'm eating that...",
	"celldoor": "A rusty old door, with a big keyhole...\nMaybe if I shout through it, I can convince the warden to\ngive me a key!..."
}

func any_visible():
	var any = false
	for v in vis:
		if vis[v]:
			any = true
	return any
	
func get_interactable():
	for v in vis:
		if vis[v]:
			return v
	return null

func _ready():
	visible = false
	for n in full_names.keys():
		vis[n] = false
		
	print("full names = ", full_names)

func _process(delta):
	pass

func _on_world_player_can_interact(avail : bool, name : String):
	print("can interact with " + name + "?: " + str(avail))
	vis[name] = avail
	visible = any_visible()
	
	if avail:
		text = "Press q to interact with " + full_names[name]
	else:
		if any_visible():
			text = "Press q to interact with " + full_names[get_interactable()]
		else:
			text = "???"
	
func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_Q:
		var interactable = get_interactable()
		if interactable:
			get_parent().get_node("dialog") \
				.freeze_run(descs[interactable], "res://zaz.jpg")
