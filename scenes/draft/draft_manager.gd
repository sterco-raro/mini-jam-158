class_name DraftManager extends Node2D

@export
var DECK: Node2D

const MIN_DRAFT_SIZE: int = 5
const MAX_DRAFT_SIZE: int = 8

const CARD_VALUES: Array[int] = [ 1, 5, 10, 20, 50 ]
const CARD_VALUES_SIZE: int = 5

var _current_draft: Array[Card]

var _selected_cards: Array[int]

var _card: PackedScene = preload("res://scenes/card.tscn")

func _ready():
	assert(DECK != null, "DECK is null")
	#_generate_new_draft()

func _on_card_select():
	# if already selected: deselect
	# else
		# if DECK.available < DECK.total:
			# Add to selected hand
			# Start animation
			# Update deck counter
			#EventBusUi.update_deck_counter.emit(DECK.available + 1, DECK.total)
	pass

func _generate_new_draft():
	# Reset available values
	var used_values: Array[int] = []
	# Pick draft size
	var draft_size: int = randi_range(MIN_DRAFT_SIZE, MAX_DRAFT_SIZE)
	# Generate cards
	var value: int
	var new_card: CardData
	var _node: Node2D
	var _sprite: Sprite2D
	var done: bool = false
	for i: int in range(draft_size):
		# Assign a random value from available card values
		while (!done):
			value = CARD_VALUES[ randi() % CARD_VALUES_SIZE ]
			if value not in used_values:
				done = true
				used_values.append(value)
		# Create card
		new_card = CardData.new()
		new_card.index = i
		new_card.name = CARD_TYPES[i][0]
		new_card.value = value
		new_card.texture_path = CARD_TYPES[i][1]
		# Create node
		_node = _card.instantiate() as Card
		_node.index = i
		_node.type = CARD_TYPES[i][0]
		_node.value = value
		(_node.get_child(0) as Sprite2D).texture = CARD_TYPES[i][1]
		# Add to draft
		_current_draft.append(new_card)
	print_debug(_current_draft)
