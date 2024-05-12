class_name BattleManager extends Node2D

const CARD_PREFABS: Dictionary = {
	"Alpha": preload("res://scenes/cards/card_alpha.tscn"),
	"Beta": preload("res://scenes/cards/card_beta.tscn"),
	"Gamma": preload("res://scenes/cards/card_gamma.tscn"),
	"Delta": preload("res://scenes/cards/card_delta.tscn"),
	"Epsilon": preload("res://scenes/cards/card_epsilon.tscn")
}

var player_hand: Array[Card]
var shopkeeper_hand: Array[Card]

var player_deck: Array[Card]

@export
var available_changes: int = 2

var DECK: Deck

func init_battle():
	var card: Card
	var index: int = 0
	for key in DECK.cards.keys():
		if DECK.cards[key]["quantity"] == 0:
			continue
		for i: int in DECK.cards[key]["quantity"]:
			card = CARD_PREFABS[key].instantiate()
			card.index = index
			player_deck.append(card)
			index += 1

	# Clone two cards from player's deck
	_pick_shopkeeper_hand()
	# Draw four cards from player's deck
	_pick_player_hand()

func _pick_shopkeeper_hand():
	var type: String
	var left_card: Card
	var right_card: Card
	var done: bool = false
	# Left card
	while (!done):
		type = DECK.cards.keys().pick_random()
		if DECK.cards[type]["quantity"] == 0:
			continue
		done = true
	left_card = CARD_PREFABS[type].instantiate()
	left_card.disable_tweens = true
	left_card.index = 0
	shopkeeper_hand.append(left_card)
	%CardSlotLeft.add_child(left_card)
	# Right card
	done = false
	while (!done):
		type = DECK.cards.keys().pick_random()
		if DECK.cards[type]["quantity"] == 0:
			continue
		if type == left_card.type and DECK.cards[type]["quantity"] < 2:
			continue
		done = true
	right_card = CARD_PREFABS[type].instantiate()
	right_card.disable_tweens = true
	right_card.index = 1
	shopkeeper_hand.append(right_card)
	%CardSlotRight.add_child(right_card)

func _pick_player_hand():
	pass
