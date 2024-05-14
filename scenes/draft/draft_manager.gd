class_name DraftManager extends Node2D

const MIN_DRAFT_SIZE: int = 24
const MAX_DRAFT_SIZE: int = 32

var _current_draft: Array[Card]
var _selected_cards: Array[int]

@onready
var _cards_container: Node2D = $Drawer/Cards


func _ready():
	EventBusGame.card_select.connect(_on_card_select)

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
	var border: int = 32
	var hitbox_size: int = 8
	var drawer_rect: Rect2 = ($Drawer/Sprite2D as Sprite2D).get_rect()

	# rect position is top-left usually
	var min_x = drawer_rect.position.x + border
	var min_y = drawer_rect.position.y + border
	# rect size is the width and height from position
	var max_x = drawer_rect.size.x - border
	var max_y = drawer_rect.size.y - border

	var point: Vector2
	var count: int = 0
	var done: bool = false
	var overlap: bool = false
	while (!done):
		point = Vector2(randi_range(min_x, max_x), randi_range(min_y, max_y))

		if !drawer_rect.has_point(point): continue

		card.position = point
		card.rotate(randf_range(0, 2 * PI))

		var hitbox: Rect2 = Rect2(point, Vector2(hitbox_size, hitbox_size))
		for c: Card in _current_draft:
			if c == card:
				continue
			if hitbox.has_point(c.position):
				overlap = true
				break

		if !overlap:
			done = true

		if count >= 5:
			done = true
		count += 1

func _on_card_select(index: int):
	if index in _selected_cards:
		# Deselect card
		_selected_cards.erase(index)
		EventBusGame.draft_card_select.emit(index, false)
	else:
		# Select card if there's still some space left
		if _selected_cards.size() < Constants.DECK_MAX_CARDS:
			_selected_cards.append(index)
			EventBusGame.draft_card_select.emit(index, true)
		else:
			# No need to update the UI
			return

	EventBusUi.deck_ui_update.emit(_selected_cards.size(), Constants.DECK_MAX_CARDS)


func _on_countdown_timeout():
	var cards: Array[Card] = []
	for idx: int in _selected_cards:
		cards.append( _current_draft[ idx ] )

	EventBusGame.deck_update.emit(cards)
	EventBusGame.summary_update_draft.emit(cards)
	EventBusGame.game_start.emit()
