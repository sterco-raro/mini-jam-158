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
	EventBusGame.game_new.connect(_handle_game_new)
	EventBusGame.game_start.connect(_handle_game_start)
	EventBusGame.game_end.connect(_handle_game_end)

	EventBusGame.battle_start.connect(_on_battle_start)

	EventBusGame.shopping_cart_add_item.connect(_on_shopping_cart_add_item)
	EventBusGame.shopping_cart_remove_item.connect(_on_shopping_cart_remove_item)
	EventBusGame.wishlist_add_item.connect(_on_wishlist_add_item)
	EventBusGame.wishlist_remove_item.connect(_on_wishlist_remove_item)

	EventBusGame.wishlist_randomize.connect(_on_wishlist_randomize)

	# TODO change_scene to main menu on startup, remove paue/resume

	# Set container nodes process mode to handle paused/unpaused state
	scene_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	main_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Pause the app, hide the scene and show the menu
	EventBusUi.pause.emit()


func _process(_delta: float):
	# DEBUG CONTROLS
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)

	if Input.is_action_just_pressed("test1"):
		EventBusGame.game_end.emit(false)
	elif Input.is_action_just_pressed("test2"):
		EventBusGame.game_end.emit(true)
	# END DEBUG CONTROLS

	if _running:
		# Game over conditions
		if shopping_cart.equals(wishlist):
			EventBusGame.game_end.emit(true)
		else:
			if deck.is_empty():
				EventBusGame.game_end.emit(false)


func _on_pause():
	scene_container.hide()
	main_menu.show()


func _on_resume():
	scene_container.show()
	main_menu.hide()


func _on_battle_start():
	var card: Card
	var index: int = 0
	var cards: Array[Card] = []

	# Build a list of Cards from the deck data
	for key in deck.cards:
		for i: int in deck.cards[key]["quantity"]:
			card = Constants.PREFAB_CARDS[key.type].instantiate()
			card.index = index
			card.disable_tweens = true
			cards.append(card)
			index += 1

	EventBusGame.battle_set_player_deck.emit(cards)


func _on_shopping_cart_add_item(item: Constants.ITEMS):
	shopping_cart.add_item(item)
	EventBusUi.shopping_cart_ui_update.emit(shopping_cart)


func _on_shopping_cart_remove_item(item: Constants.ITEMS):
	shopping_cart.remove_item(item)
	EventBusUi.shopping_cart_ui_update.emit(shopping_cart)


func _on_wishlist_add_item(item: Constants.ITEMS):
	wishlist.add_item(item)
	EventBusUi.wishlist_ui_update.emit(wishlist)


func _on_wishlist_remove_item(item: Constants.ITEMS):
	wishlist.remove_item(item)
	EventBusUi.wishlist_ui_update.emit(wishlist)


func _on_wishlist_randomize(items: Dictionary):
	var total: int = 0
	var value: int = 0

	# Pick random values for each item
	for key in items:
		value = randi_range(0, items[key] / 2 + 1)
		wishlist.set_item(key, value)
		if value > 0:
			total += 1

	# Avoid empty wishlists
	if total == 0:
		var key = Constants.ITEMS.keys().pick_random()
		value = randi_range(1, items[key] / 2 + 1)
		wishlist.set_item(key, value)

	EventBusUi.wishlist_ui_update.emit(wishlist)

	# TODO better summary screen handling
	EventBusGame.summary_update_wishlist.emit(wishlist)


func _handle_game_new():
	# Clear old game data
	deck.clear()
	shopping_cart.clear()
	wishlist.clear()

	# TODO move this update where it belongs
	EventBusUi.deck_ui_update.emit(deck.available_cards, Constants.DECK_MAX_CARDS)

	EventBusUi.shopping_cart_ui_update.emit(shopping_cart)
	EventBusUi.wishlist_ui_update.emit(wishlist)

	# Set up draft screen instance
	var draft_screen: DraftManager = ScenesData.SCENE_01_DRAFT.instantiate()

	# Switch scene (add to active node)
	_change_scene(draft_screen)


func _handle_game_start():
	var market_screen: MarketManager = ScenesData.SCENE_02_MARKET.instantiate()

	# TODO move this update where it belongs
	EventBusUi.deck_ui_update.emit(deck.available, deck.max_cards)

	_change_scene(market_screen)

	_running = true


func _handle_game_end(win: bool):
	# TODO  update summary data
	var summary: Summary = ScenesData.SCENE_03_SUMMARY.instantiate()

	summary.win = win

	_change_scene(summary)

	_running = false


func _change_scene(instance: Node):
	# Clear the current scene by deleting all children
	var count: int = scene_container.get_child_count()
	for i in range(count):
		scene_container.get_child(i).queue_free()
	# Add new instance to the current scene and resume gameplay
	scene_container.add_child(instance)
	EventBusUi.resume.emit()
