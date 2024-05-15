class_name Deck
extends RefCounted

const initial_deck_size: int = Constants.DECK_INITIAL_SIZE
const max_cards: int = Constants.DECK_MAX_CARDS

var available_cards: int = 0

var cards: Dictionary = {
	Constants.CARDS.ALPHA: 		0,
	Constants.CARDS.BETA:  		0,
	Constants.CARDS.GAMMA: 		0,
	Constants.CARDS.DELTA: 		0,
	Constants.CARDS.EPSILON: 	0,
}


func add_cards(new_cards: Array[Card]):
	for card: Card in new_cards:
		cards[card.type] += 1
	available_cards = new_cards.size()


func clear():
	for key in cards:
		cards[key] = 0
	available_cards = 0


func init():
	var key: Constants.CARDS
	for i: int in initial_deck_size:
		key = Constants.CARDS[ Constants.CARDS.keys().pick_random() ]
		cards[key] += 1
	available_cards = initial_deck_size


func is_empty() -> bool:
	for key in cards:
		if cards[key] > 0:
			return false
	return true


func update(new_cards: Array[Card]):
	clear()
	add_cards(new_cards)
