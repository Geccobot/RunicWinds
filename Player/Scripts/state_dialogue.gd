class_name State_Dialogue 
extends State

func Enter() -> void:
	player.velocity = Vector2.ZERO
	player.UpdateAnimation("idle")
	if player.dialogue_timeline != "":
		Dialogic.start(player.dialogue_timeline)
	else:
		print("No timeline assigned!")

func Exit() -> void:
	player.dialogue_timeline = ""

func Process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	if not Dialogic.current_timeline:  # no active timeline
		return player.idle
	return null

func HandleInput(_event: InputEvent) -> State:
	# Do nothing: block gameplay inputs
	return null
