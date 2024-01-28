extends Node3D

@onready var player : CharacterBody3D = $player
@onready var interaction_parent = $interact_points

signal player_can_interact # (bool, string)

func _ready():
	for ch : Area3D in interaction_parent.get_children():
		ch.body_entered.connect(interactable_body_entered.bind(ch.name))
		ch.body_exited.connect(interactable_body_exited.bind(ch.name))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interactable_body_entered(body : Node3D, name : String):
	print("Body entered an area3d")
	if body == player:
		print("Body is player")
		player_can_interact.emit(true, name)
	
func interactable_body_exited(body : Node3D, name : String):
	if body == player:
		player_can_interact.emit(false, name)
