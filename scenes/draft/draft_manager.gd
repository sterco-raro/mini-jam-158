class_name DraftManager
extends Node2D

const MIN_DRAFT_SIZE: int = 24
const MAX_DRAFT_SIZE: int = 32

var _current_draft: Array[Card]
var _selected_cards: Array[int]

@onready
var _cards_container: Node2D = $Drawer/Cards


func _ready():
	EventBusGame.draft_card_select.connect(_on_draft_card_select)
	%ProgressBar.max_value = %Countdown.wait_time
	_generate_new_draft()


func _process(_delta):
	%ProgressBar.value = %Countdown.wait_time - %Countdown.time_left


func _generate_new_draft():
	_empty_old_hand()
	_pick_random_hand()


func _empty_old_hand():
	var count: int = _cards_container.get_child_count()
	for i: int in count:
		_cards_container.get_child(i).queue_free()


func _pick_random_hand():
	var card: Card
	var type: Constants.CARDS
	var draft_size: int = randi_range(MIN_DRAFT_SIZE, MAX_DRAFT_SIZE)

	for i: int in draft_size:
		type = Constants.CARDS[ Constants.CARDS.keys().pick_random() ]
		card = Constants.PREFAB_CARDS[type].instantiate()
		card.index = i

		_current_draft.append(card)
		_cards_container.add_child(card)
		_randomize_position_and_rotation(card)


func _randomize_position_and_rotation(card: Node2D):
	var inner_border: int = 32
	var card_hitbox_size: int = 8
	var container_rect: Rect2 = ($Drawer/Sprite2D as Sprite2D).get_rect()

	# Rect position is the sprite's top left point
	var min_x = container_rect.position.x + inner_border
	var min_y = container_rect.position.y + inner_border
	# Rect size is the sprite's width and height
	var max_x = (container_rect.position.x + container_rect.size.x) - inner_border
	var max_y = (container_rect.position.y + container_rect.size.y) - inner_border

	var count: int = 0
	var point: Vector2
	var card_hitbox: Rect2
	var done: bool = false
	var overlap: bool = false
	while (!done):
		# Pick a new random point inside the container inner border
		point = Vector2(randi_range(min_x, max_x), randi_range(min_y, max_y))

		# Random card position and rotation
		card.position = point
		card.rotate(randf_range(0, 2 * PI))

		# Avoid overlaps within a small range
		overlap = false
		card_hitbox = Rect2(point, Vector2(card_hitbox_size, card_hitbox_size))
		for c: Card in _current_draft:
			if c == card:
				continue
			if card_hitbox.has_point(c.position):
				overlap = true
				break
		if !overlap:
			done = true
			break

		# Last resort to avoid infinite loops: do only five iterations for each card
		if count >= 5:
			done = true
			break
		count += 1


func _on_draft_card_select(index: int):
	var available_cards: int = Constants.DECK_INITIAL_SIZE + _selected_cards.size()

	# Deselect card
	if index in _selected_cards:
		_selected_cards.erase(index)
		EventBusGame.card_select.emit(index, false)

	# Select card if there's still some space left
	else:
		if available_cards < Constants.DECK_MAX_CARDS:
			_selected_cards.append(index)
			EventBusGame.card_select.emit(index, true)

	available_cards = Constants.DECK_INITIAL_SIZE + _selected_cards.size()
	EventBusUi.deck_ui_update.emit(available_cards, Constants.DECK_MAX_CARDS)


func _on_countdown_timeout():
	var cards: Array[Card] = []
	for index: int in _selected_cards:
		cards.append( _current_draft[ index ] )

	EventBusGame.deck_add_cards.emit(cards)

	# TODO summary screen issues
	EventBusGame.summary_update_draft.emit(cards)

	EventBusGame.game_start.emit()
