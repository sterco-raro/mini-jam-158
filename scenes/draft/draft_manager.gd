class_name DraftManager extends Node2D

@export
var DECK_AVAILABLE: int = 0
@export
var DECK_TOTAL: int = 3

@onready
var _cards_container: Node2D = $Drawer/Cards

const MIN_DRAFT_SIZE: int = 5
const MAX_DRAFT_SIZE: int = 8

const CARD_VALUES: Array[int] = [ 1, 5, 10, 20, 50 ]
const CARD_VALUES_SIZE: int = 5

# int value, PackedScene
var _card_prefabs : Array[Array] = [
	[ "alpha", 0, preload("res://scenes/cards/card_alpha.tscn") ],
	[ "beta", 0, preload("res://scenes/cards/card_beta.tscn") ],
	[ "gamma", 0, preload("res://scenes/cards/card_gamma.tscn") ],
	[ "delta", 0, preload("res://scenes/cards/card_delta.tscn") ],
	[ "epsilon", 0, preload("res://scenes/cards/card_epsilon.tscn") ]
]
const CARD_PREFABS_SIZE: int = 5

var _current_draft: Array[Card]
var _selected_cards: Array[int]

func _ready():
	EventBusGame.card_select.connect(_on_select_card)
	_generate_new_draft()

func _generate_new_draft():
	# Assign card values
	_shuffle_card_values()
	# Clear last draft cards
	_empty_old_hand()
	# Generate random cards hand
	_pick_random_hand()

func _shuffle_card_values():
	var value: int
	var done: bool = false
	var used_values: Array[int] = []
	for i: int in CARD_PREFABS_SIZE:
		while (!done):
			value = CARD_VALUES[ randi() % CARD_VALUES_SIZE ]
			if value not in used_values:
				done = true
				used_values.append(value)
				_card_prefabs[i][1] = value
		done = false

func _empty_old_hand():
	var count: int = _cards_container.get_child_count()
	for i: int in count:
		_cards_container.get_child(i).queue_free()

func _pick_random_hand():
	var type: int
	var card: Card
	var draft_size: int = randi_range(MIN_DRAFT_SIZE, MAX_DRAFT_SIZE)
	for i: int in draft_size:
		# Card type
		# TODO add weighted chances: pick a value in 0-100 and assign ranges to the array indexes 0-5
		type = randi() % CARD_PREFABS_SIZE
		# Card data
		card = _card_prefabs[type][2].instantiate()
		card.index = i
		card.value = _card_prefabs[type][1]
		# Node position
		_cards_container.add_child(card)
		_randomize_position_and_rotation(card)
		_current_draft.append(card)

func _randomize_position_and_rotation(card: Node2D):
	var border = 32
	var sprite_rect: Rect2 = ($Drawer/Sprite2D as Sprite2D).get_rect()

	# rect position is top-left usually
	var min_x = sprite_rect.position.x + border
	var min_y = sprite_rect.position.y + border
	# rect size is the width and height from position
	var max_x = sprite_rect.size.x - border
	var max_y = sprite_rect.size.y - border

	var done = false
	var overlap = false
	var point: Vector2
	while (!done):
		point = Vector2(randi_range(min_x, max_x), randi_range(min_y, max_y))

		if !sprite_rect.has_point(point): continue

		card.position = point
		card.rotate(randf_range(0, 2 * PI))

		var rect: Rect2 = Rect2(point, Vector2(border, border))
		for c: Card in _current_draft:
			if rect.has_point(c.position):
				overlap = true
		if !overlap:
			done = true

func _on_select_card(index: int):
	# Update selection
	if index in _selected_cards:
		_selected_cards.erase(index)
		DECK_AVAILABLE -= 1
		EventBusGame.draft_card_select.emit(index, false)
	else:
		if DECK_AVAILABLE < DECK_TOTAL:
			_selected_cards.append(index)
			DECK_AVAILABLE += 1
			EventBusGame.draft_card_select.emit(index, true)
	# Update UI
	EventBusUi.deck_counter_update.emit(DECK_AVAILABLE, DECK_TOTAL)
