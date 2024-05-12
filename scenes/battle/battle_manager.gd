class_name BattleManager extends Node2D

const CARD_PREFABS: Dictionary = {
	"Alpha": preload("res://scenes/cards/card_alpha.tscn"),
	"Beta": preload("res://scenes/cards/card_beta.tscn"),
	"Gamma": preload("res://scenes/cards/card_gamma.tscn"),
	"Delta": preload("res://scenes/cards/card_delta.tscn"),
	"Epsilon": preload("res://scenes/cards/card_epsilon.tscn")
}

var player_hand: Array[Card]
var shopkeeper_hand_left: Card
var shopkeeper_hand_right: Card

var player_deck: Array[Card]

var selected_cards: Array[Card]

@export
var available_changes: int = 2

var DECK: Deck

@onready
var _change_button: Button = %ChangeButton

@onready
var _confirm_button: Button = %ConfirmButton

var _in_battle: bool = false

func _ready():
	EventBusGame.battle_card_select.connect(_on_battle_card_select)
	_change_button.disabled = true
	_confirm_button.disabled = true

func _process(_delta):
	if _in_battle:
		var player_sum: int = 0
		var shopkeeper_sum: int = 0

		if player_deck.size() == 0:
			_in_battle = false
			EventBusGame.battle_end.emit(false)

		if available_changes == 0:
			player_sum = 0
			shopkeeper_sum = 0
			for card: Card in player_hand:
				player_sum += card.value
			shopkeeper_sum = shopkeeper_hand_left.value + shopkeeper_hand_right.value
			if player_sum <= shopkeeper_sum:
				_in_battle = false
				EventBusGame.battle_end.emit(false)

		# Change cards button activation logic
		if available_changes > 0:
			if _change_button.disabled and selected_cards.size() > 0:
				_change_button.disabled = false
			if !_change_button.disabled and selected_cards.size() == 0:
				_change_button.disabled = true
		else:
			if !_change_button.disabled:
				_change_button.disabled = true

		# Confirm hand button activation logic
		player_sum = 0
		shopkeeper_sum = 0
		for card: Card in selected_cards:
			player_sum += card.value
		shopkeeper_sum = shopkeeper_hand_left.value + shopkeeper_hand_right.value
		if _confirm_button.disabled and player_sum > shopkeeper_sum:
			_confirm_button.disabled = false
		if !_confirm_button.disabled and player_sum <= shopkeeper_sum:
			_confirm_button.disabled = true

func _on_battle_card_select(card: Card):
	var index: int = selected_cards.find(card)
	# New, unselected card
	if index == -1:
		selected_cards.append(card)
	# Already selected card
	else:
		selected_cards.remove_at(index)

func activate_cooldowns():
	for i: int in range(4):
		(get_node("PlayerHand/CardSlot%s" % (i + 1)) as CardSlot)._click_cooldown.start()

func init_battle():
	_get_player_cards_as_list()
	# Clone two cards from player's deck
	_pick_shopkeeper_hand()
	# Draw four cards from player's deck
	_pick_player_hand()
	_in_battle = true

func _get_player_cards_as_list():
	var card: Card
	var index: int = 0
	for key in DECK.cards.keys():
		if DECK.cards[key]["quantity"] == 0:
			continue
		for i: int in DECK.cards[key]["quantity"]:
			card = CARD_PREFABS[key].instantiate()
			card.index = index
			card.disable_tweens = true
			player_deck.append(card)
			index += 1

func _pick_shopkeeper_hand():
	var type: String
	var done: bool = false
	# Left card
	while (!done):
		type = DECK.cards.keys().pick_random()
		if DECK.cards[type]["quantity"] == 0:
			continue
		done = true
	shopkeeper_hand_left = CARD_PREFABS[type].instantiate()
	shopkeeper_hand_left.disable_tweens = true
	shopkeeper_hand_left.index = 0
	%CardSlotLeft.get_child(0).add_child(shopkeeper_hand_left)
	# Right card
	done = false
	while (!done):
		type = DECK.cards.keys().pick_random()
		if DECK.cards[type]["quantity"] == 0:
			continue
		if type == shopkeeper_hand_left.type and DECK.cards[type]["quantity"] < 2:
			continue
		done = true
	shopkeeper_hand_right = CARD_PREFABS[type].instantiate()
	shopkeeper_hand_right.disable_tweens = true
	shopkeeper_hand_right.index = 1
	%CardSlotRight.get_child(0).add_child(shopkeeper_hand_right)

func _pick_player_hand():
	var card: Card
	var idx: int = -1
	for i: int in range(mini(4, player_deck.size())):
		idx = randi() % player_deck.size()
		card = player_deck[idx] as Card
		card.index = i
		player_hand.append(card)
		player_deck.remove_at(idx)
		get_node("PlayerHand/CardSlot%s" % (i + 1)).add_card(card)

func _on_change_button_pressed():
	var index: int
	var card: Card
	var slot: CardSlot

	# Destroy selected cards
	var selection_size: int = selected_cards.size()
	for i: int in selection_size:
		index = player_hand.find(selected_cards[i])
		if index == -1:
			continue
		# Remove card from player hand
		player_hand.remove_at(index)
		# Remove card from CardSlot
		card = get_node("PlayerHand/CardSlot%s" % (selected_cards[i].index + 1)).remove_card()
		# Destroy card node
		card.queue_free()
	# Remove cards from selection
	selected_cards.clear()

	# Update player hand indexes
	index = -1
	card = null
	for i: int in player_hand.size():
		# Take card that needs to be shifted
		if player_hand[i].index != i:
			card = get_node("PlayerHand/CardSlot%s" % (player_hand[i].index + 1)).remove_card()
			# Shift card in first empty slot
			for j: int in range(4):
				slot = get_node("PlayerHand/CardSlot%s" % (j + 1))
				if slot.card == null:
					slot.add_card(card)
					player_hand[i].index = j
					break

	# Draw replacement cards
	index = -1
	card = null
	slot = null
	for i: int in selection_size:
		index = randi() % player_deck.size()
		card = player_deck[index]
		# Place new card in the first available empty slot
		for j: int in range(4):
			slot = get_node("PlayerHand/CardSlot%s" % (j + 1))
			print(slot.get_child(0).get_children())
			if slot.card == null:
				card.index = j
				slot.add_card(card)
				player_hand.append(card)
				player_deck.remove_at(index)

	# Deselect all card slots
	for i: int in range(4):
		slot = get_node("PlayerHand/CardSlot%s" % (i + 1))
		slot.selected = false
		slot._on_area_2d_mouse_exited()

	# Update available changes counter
	available_changes -= 1

func _on_confirm_button_pressed():
	var card: Card
	var index: int = -1
	# Destroy selected cards
	var selection_size: int = selected_cards.size()
	for i: int in selection_size:
		index = player_hand.find(selected_cards[i])
		if index == -1:
			continue
		# Remove card from player hand
		player_hand.remove_at(index)
		# Remove card from CardSlot
		card = get_node("PlayerHand/CardSlot%s" % (selected_cards[i].index + 1)).remove_card()
		# Destroy card node
		card.queue_free()
	selected_cards.clear()
	# Destroy shopkeeper cards
	card = %CardSlotLeft.remove_card()
	if card:
		card.queue_free()
	card = %CardSlotRight.remove_card()
	if card:
		card.queue_free()
	shopkeeper_hand_left.queue_free()
	shopkeeper_hand_right.queue_free()
	# Put unused cards from player hand back into the deck
	for i: int in player_hand.size():
		player_deck.append(player_hand[i])
	player_hand.clear()
	for i: int in player_deck.size():
		player_deck[i].index = i
	# Update player deck
	DECK.clear()
	EventBusGame.deck_update.emit(player_deck)
	# Go back to market scene
	_in_battle = false
	EventBusGame.battle_end.emit(true)
