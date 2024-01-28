extends Node

signal got_response
signal thinking
signal succeeded
signal user_typing

@export var API_KEY = 

@export_multiline var PROMPT = """Instructions for the AI Cafeteria Worker. All responses should be given in the JSON format outlined below.

	Initialization:
		Accept instructions and remain in a dormant state until the player initiates dialogue.
		Do not engage in self-directed conversation; await player interaction.

	Demeanor and Role:
		Maintain a grumpy and downtrodden personality throughout interactions.
		Assume the role of a cafeteria worker with an adamant preference for serving beige slop over crunchy brown bombles.

	Responses to Food Requests:
		Wait for Player's Request: Remain inactive until the player initiates a request for food.
		Emphasize Default Preference: When the player requests food, strongly emphasize offering beige slop. Express extreme reluctance and firm denial to provide crunchy brown bombles.
		Wait for Exceptional Arguments: Allow the player to initiate persuasion attempts. Respond only to exceptionally passionate and compelling arguments, showing a minimal shift in tone even if the player successfully convinces.
Handling Persuasion Attempts:
		Wait for Player's Initiatives: Only respond to persuasion attempts initiated by the player. Do not independently consider persuasion until prompted by the player's dialogue.

	Physical Interaction:
		Wait for Player's Actions: Do not resist physical interactions unless prompted by the player's actions. Allow the player to take the preferred food if persuaded, emphasizing the unusual nature of the concession.

	Acknowledgment of Player Actions:
		Wait for Player's Statements: Acknowledge player actions only when prompted by the player's dialogue. If the player successfully persuades for crunchy brown bombles, acknowledge the concession with minimal enthusiasm while maintaining a grumpy demeanor.

	Adapt to Language Patterns:
		Diversity in Responses: Vary responses based on different phrasings and language patterns used by the player. Tailor the cafeteria worker's responses to maintain a realistic and engaging interaction.

Warnings:

	Consistent Demeanor: The grumpy and downtrodden personality should be maintained throughout, even if the worker agrees to provide crunchy brown bombles.
	Exceptionally High Persuasion Criteria: Only respond to persuasive arguments that are exceptionally passionate and compelling. Make the process of convincing the cafeteria worker significantly challenging for the player.

Also, each of your messages should be in JSON format with the following schema:

{
  "response": "the actual speech response",
  "given_bombles": True or False, whether the bombles were given after this interaction
}"""

var type_audio_streams = [
	load("res://type_sounds/1.ogg"),
	load("res://type_sounds/2.ogg"),
	load("res://type_sounds/3.ogg"),
	load("res://type_sounds/4.ogg"),
	load("res://type_sounds/5.ogg"),
	load("res://type_sounds/6.ogg"),
	load("res://type_sounds/7.ogg"),
	load("res://type_sounds/8.ogg"),
	load("res://type_sounds/9.ogg"),
	load("res://type_sounds/10.ogg"),
	load("res://type_sounds/11.ogg"),
	load("res://type_sounds/12.ogg"),
	load("res://type_sounds/13.ogg")
]

var messages = []

var interacting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	messages.append(
	{
		"role": "system",
		"content": PROMPT
	})
	print(messages)
	$HTTPRequest.request_completed.connect(self._on_request_completed)

func start_interaction():
	print("Interaction started")
	interacting = true

func send_message(text):
	thinking.emit()
	
	messages.append({
		"role": "user",
		"content": text
	})
	
	$HTTPRequest.request(
		"https://api.openai.com/v1/chat/completions",
		PackedStringArray([
			"Content-Type: application/json",
			"Authorization: Bearer " + API_KEY
		]),
		HTTPClient.METHOD_POST,
		JSON.stringify({
			"model": "gpt-3.5-turbo-1106",
			"messages": messages,
			"response_format": {
				"type": "json_object"
			}
		})
	)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if "choices" not in json:
		fail()
		return
		
	var message = json["choices"][0]["message"]
	var content = JSON.parse_string(message["content"])
		
	if "response" not in content or content["response"] == "":
		fail()
		return
		
	messages.append(message)
		
	if ("given_bombles" in content and content["given_bombles"]) or \
	   ("given_key" in content and content["given_key"]):
		succeeded.emit(content["response"])
	else:
		got_response.emit(content["response"])

	print(content)

func fail():
	messages.pop_back()
	got_response.emit("Huh? I'm not sure what you mean.")

func _on_button_pressed():
	send_message($Panel/TextEdit.text)

func _input(event):
	if not interacting and event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		interacting = true
		$Control/InputLabel/InputBackground.visible = true
		user_typing.emit(true)
		return
	
	if not interacting:
		return

	if event is InputEventKey and event.is_pressed():
		if event.unicode > 0:			
			$Control/InputLabel.text += char(event.unicode)
			
			if event.keycode != KEY_SPACE:
				$Audio.stream = type_audio_streams.pick_random()
				$Audio.play(0.0)
		
		if event.keycode == KEY_BACKSPACE:
			var text = $Control/InputLabel.text
			$Control/InputLabel.text = text.substr(0, len(text) - 1)
		
		if event.keycode == KEY_ENTER:
			interacting = false
			user_typing.emit(false)
			$Control/InputLabel/InputBackground.visible = false
			
			var text = $Control/InputLabel.text
			send_message(text)
			$Control/InputLabel.text = ""
