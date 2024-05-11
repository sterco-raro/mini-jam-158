extends Node2D

@export
var DECK: Deck

@export
var CONTAINER: Node2D

@export
var UI_CONTAINER: Node

func _ready():
	assert(DECK != null, "DECK is null")
	assert(CONTAINER != null, "CONTAINER is null")
	assert(UI_CONTAINER != null, "UI_CONTAINER is null")

	EventBusUi.pause.connect(_on_pause)
	EventBusUi.resume.connect(_on_resume)

	EventBusGame.scene_change.connect(_handle_scene_change)
	EventBusGame.game_new.connect(_handle_game_new)
	EventBusGame.game_start.connect(_handle_game_start)
	EventBusGame.game_end.connect(_handle_game_end)

	CONTAINER.process_mode = Node.PROCESS_MODE_PAUSABLE
	UI_CONTAINER.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Pause the app, hide the scene and show the menu
	EventBusUi.pause.emit()

func _process(_delta):
	# Quit the app
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)

	# Toggle the main menu
	if Input.is_action_just_pressed("toggle_menu"):
		if get_tree().paused:
			if CONTAINER.get_children().size() > 0:
				EventBusUi.resume.emit()
		else:
			EventBusUi.pause.emit()

func _empty_scene():
	var count: int = CONTAINER.get_child_count()
	for i in range(count):
		CONTAINER.get_child(i).queue_free()

func _handle_game_new():
	# Empty current deck
	#DECK.clear()
	# Set up Draft screen
	var draft_screen: DraftManager = ScenesData.SCENE_01_DRAFT.instantiate() as DraftManager
	draft_screen.DECK_AVAILABLE = DECK.available
	draft_screen.DECK_TOTAL = DECK.total
	# Switch scene (add to active node)
	EventBusGame.scene_change.emit(draft_screen)

func _handle_game_start():
	var market_screen: MarketManager = ScenesData.SCENE_02_MARKET.instantiate() as MarketManager
	market_screen.DECK = DECK
	EventBusGame.scene_change.emit(market_screen)

func _handle_game_end():
	var summary: Summary = ScenesData.SCENE_03_SUMMARY.instantiate() as Summary
	EventBusGame.scene_change.emit(summary)

func _handle_scene_change(instance: Node):
	_empty_scene()
	CONTAINER.add_child(instance)
	EventBusUi.resume.emit()

func _on_pause():
	CONTAINER.hide()
	UI_CONTAINER.show()

func _on_resume():
	CONTAINER.show()
	UI_CONTAINER.hide()
