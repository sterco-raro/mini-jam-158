class_name GameManager
extends Node2D
## The app skeleton, handles all the infrastructure needed to play the game

@export
var main_menu: Node
@export
var scene_container: Node2D

var deck: Deck = Deck.new()
var shopping_cart: Cart = Cart.new()
var wishlist: Cart = Cart.new()

var _running: bool = false


func _ready():
	assert(deck != null, "deck is null")
	assert(main_menu != null, "main_menu is null")
	assert(scene_container != null, "scene_container is null")

	# UI signals
	EventBusUi.pause.connect(_on_pause)
	EventBusUi.resume.connect(_on_resume)

	# Game signals
	EventBusGame.game_new.connect(_on_game_new)
	EventBusGame.game_start.connect(_on_game_start)
	EventBusGame.game_end.connect(_on_game_end)

	EventBusGame.battle_request_deck.connect(_on_battle_request_deck)

	EventBusGame.deck_add_cards.connect(_on_deck_add_cards)
	EventBusGame.deck_update.connect(_on_deck_update)

	EventBusGame.shopping_cart_add_item.connect(_on_shopping_cart_add_item)

	EventBusGame.wishlist_randomize.connect(_on_wishlist_randomize)

	# TODO change_scene to main menu on startup, remove paue/resume

	# Set container nodes process mode to handle paused/unpaused state
	scene_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	main_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Pause the app, hide the scene and show the menu
	EventBusUi.pause.emit()


func _process(_delta: float):
	# Debug controls
	#if Input.is_action_just_pressed("quit"):
		#get_tree().quit(0)

	#if Input.is_action_just_pressed("test1"):
		#EventBusGame.game_end.emit(false)
	#elif Input.is_action_just_pressed("test2"):
		#EventBusGame.game_end.emit(true)

	if _running:
		# Game over conditions
		if shopping_cart.equals(wishlist):
			EventBusGame.game_end.emit(true)
		else:
			if deck.get_size() <= 2:
				EventBusGame.game_end.emit(false)


func _on_pause():
	scene_container.hide()
	main_menu.show()


func _on_resume():
	scene_container.show()
	main_menu.hide()


func _switch_scene(instance: Node):
	# Clear the current scene by deleting all children
	var count: int = scene_container.get_child_count()
	for i in range(count):
		scene_container.get_child(i).queue_free()
	# Add new instance to the current scene and resume gameplay
	scene_container.add_child(instance)
	EventBusUi.resume.emit()


func _on_game_new():
	# Clear old game data
	deck.clear()
	shopping_cart.clear()
	wishlist.clear()

	# Generate starting deck to avoid empty drafts and related issues
	deck.init()

	# Update scene tree and UI
	var draft_screen: DraftManager = ScenesData.SCENE_01_DRAFT.instantiate()
	_switch_scene(draft_screen)
	EventBusUi.deck_ui_update.emit(deck.available_cards, Constants.DECK_MAX_CARDS)


func _on_game_start():
	var market_screen: MarketManager = ScenesData.SCENE_02_MARKET.instantiate()
	_switch_scene(market_screen)
	EventBusUi.deck_ui_update.emit(deck.available_cards, Constants.DECK_MAX_CARDS)

	# Start the main game loop
	_running = true


func _on_game_end(win: bool):
	# TODO  update summary data
	EventBusGame.summary_update_shopping_cart.emit(shopping_cart.data)

	var summary: Summary = ScenesData.SCENE_04_SUMMARY.instantiate()
	summary.win = win

	_switch_scene(summary)

	# Stop the main game loop
	_running = false


func _on_battle_request_deck():
	var card: Card
	var index: int = 0
	var cards: Array[Card] = []

	# Build a list of Cards from the deck data
	for key in deck.cards:
		for i: int in deck.cards[key]:
			card = Constants.PREFAB_CARDS[key].instantiate()
			card.index = index
			card.disable_tweens = true
			cards.append(card)
			index += 1
	EventBusGame.battle_set_deck.emit(cards)


func _on_deck_add_cards(cards: Array[Card]):
	deck.add_cards(cards)
	EventBusUi.deck_ui_update.emit(deck.available_cards, deck.max_cards)


func _on_deck_update(cards: Array[Card]):
	deck.update(cards)
	for card: Card in cards:
		card.queue_free()
	EventBusUi.deck_ui_update.emit(deck.available_cards, deck.max_cards)


func _on_shopping_cart_add_item(item: Constants.ITEMS):
	shopping_cart.add_item(item)
	EventBusUi.shopping_cart_ui_update.emit(shopping_cart.data)


func _on_wishlist_randomize(items: Dictionary):
	var total: int = 0
	var value: int = 0

	# Pick random values for each item
	for key in items:
		value = randi_range(0, max(1, items[key] / 2 - 1))
		wishlist.set_item(key, value)
		if value > 0:
			total += 1

	# Avoid empty wishlists
	if total == 0:
		var key = Constants.ITEMS.keys().pick_random()
		value = randi_range(1, max(2, items[key] / 2 - 1))
		wishlist.set_item(key, value)

	EventBusUi.wishlist_ui_update.emit(wishlist.data)

	# TODO better summary screen handling
	EventBusGame.summary_update_wishlist.emit(wishlist.data)
