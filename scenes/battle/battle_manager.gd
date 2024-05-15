class_name BattleManager extends Node2D

@export
var available_changes: int = 2

var player_hand: Array[Card]
var shopkeeper_hand_left: Card
var shopkeeper_hand_right: Card

var player_deck: Array[Card]

var selected_cards: Array[Card]

var _in_battle: bool = false

@onready
var _change_button: Button = %ChangeButton
@onready
var _confirm_button: Button = %ConfirmButton


func _ready():

	EventBusGame.battle_card_select.connect(_on_battle_card_select)
	EventBusGame.battle_set_player_deck.connect(_on_battle_set_player_deck)

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


func _on_battle_set_player_deck(cards: Array[Card]):
	player_deck = cards


func activate_cooldowns():
	for i: int in range(4):
		(get_node("PlayerHand/CardSlot%s" % (i + 1)) as CardSlot)._click_cooldown.start()


func init_battle():
	EventBusGame.battle_start.emit()

	# Clone two cards from player's deck
	_pick_shopkeeper_hand()
	# Draw four cards from player's deck
	_pick_player_hand()

	# We really need to learn finite state machines
	_in_battle = true


func _pick_shopkeeper_hand():
	var index: int
	var type: Constants.CARDS
	var deck_size: int = player_deck.size()

	index = randi() % deck_size
	type = player_deck[index].type
	shopkeeper_hand_left = Constants.PREFAB_CARDS[type].instantiate()
	shopkeeper_hand_left.disable_tweens = true
	shopkeeper_hand_left.index = 0
	%CardSlotLeft.get_child(0).add_child(shopkeeper_hand_left)

	# Avoid cards duplication by taking two consecutive cards from a random starting position
	index = (index + 1) % deck_size
	type = player_deck[index].type
	shopkeeper_hand_right = Constants.PREFAB_CARDS[type].instantiate()
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

	# TODO store burned cards for the end screen
	EventBusGame.summary_update_burned_cards.emit(selected_cards)

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

	# TODO store used cards
	EventBusGame.summary_update_used_cards.emit(selected_cards)
	EventBusGame.summary_update_total_items_cost.emit(shopkeeper_hand_left.value + shopkeeper_hand_right.value)

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
	EventBusGame.deck_update.emit(player_deck)
	# Go back to market scene
	_in_battle = false
	EventBusGame.battle_end.emit(true)
