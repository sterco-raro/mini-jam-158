class_name DraftManager extends Node2D

@export
var DECK: Node2D

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

func _ready():
	assert(DECK != null, "DECK is null")
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
				print_debug("_shuffle_card_values: current value is %d, assigned value is %d" % [ value, _card_prefabs[i][1] ])
		done = false
	print_debug(_card_prefabs)

func _empty_old_hand():
	var count: int = _cards_container.get_child_count()
	for i: int in count:
		_cards_container.get_child(i).queue_free()

func _pick_random_hand():
	var type: int
	var card: Card
	var offset: int
	var draft_size: int = randi_range(MIN_DRAFT_SIZE, MAX_DRAFT_SIZE)
	for i: int in draft_size:
		# Card type
		type = randi() % CARD_PREFABS_SIZE
		# Card data
		card = _card_prefabs[type][2].instantiate()
		card.index = i
		card.value = _card_prefabs[type][1]
		print_debug(_card_prefabs[type][1], card.value)
		# Node position
		_cards_container.add_child(card)
		offset = _cards_container.position.x / 2 + (64 + 32) * (i + 1)
		card.position += Vector2(offset, 0)
