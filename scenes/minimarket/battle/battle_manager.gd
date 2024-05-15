class_name BattleManager extends Node2D

@export
var available_changes: int = 2

var item_on_display: Item

var player_deck: Array[Card]

var player_hand: Array[Card]

var selected_cards: Array[Card]

var shopkeeper_hand_left: Card
var shopkeeper_hand_right: Card

var _in_battle: bool = false

@onready
var _change_button: Button = %ChangeButton
@onready
var _confirm_button: Button = %ConfirmButton


func _ready():
	EventBusGame.battle_card_select.connect(_on_battle_card_select)
	EventBusGame.battle_set_deck.connect(_on_battle_set_deck)
	EventBusGame.battle_set_item.connect(_on_battle_set_item)
	EventBusGame.battle_start.connect(_on_battle_start)

	%SelectionHighlight.position = %ItemDisplay.position
	%AvailableBurnLabel.text = "%d" % available_changes

	_change_button.disabled = true
	_confirm_button.disabled = true


func _process(_delta):
	if _in_battle:
		var shopkeeper_sum: int = shopkeeper_hand_left.value + shopkeeper_hand_right.value

		# End battle when the player's hand is smaller than the shopkeeper's one
		if player_hand.size() < 2:
			_in_battle = false
			EventBusGame.battle_end.emit(false)

		# No more changes available: end battle if the player can't win
		if available_changes == 0:
			if _calculate_sum(player_hand) <= shopkeeper_sum:
				_in_battle = false
				EventBusGame.battle_end.emit(false)

		# Change cards button activation logic
		if available_changes > 0:
			_change_button.disabled = selected_cards.size() == 0
		else:
			if !_change_button.disabled:
				_change_button.disabled = true

		# Confirm hand button activation logic
		_confirm_button.disabled = _calculate_sum(selected_cards) <= shopkeeper_sum


func _on_battle_card_select(card: Card):
	var index: int = selected_cards.find(card)
	# New, unselected card
	if index == -1:
		selected_cards.append(card)
	# Already selected card
	else:
		selected_cards.remove_at(index)


func _on_battle_set_deck(cards: Array[Card]):
	player_deck = cards


func _on_battle_set_item(type: Constants.ITEMS):
	if item_on_display == null:
		item_on_display = Constants.PREFAB_ITEMS[type].instantiate()
		%ItemDisplay.add_child(item_on_display)


func _on_battle_start():
	EventBusGame.battle_request_deck.emit()

	# Clone two cards from the player's deck
	_pick_shopkeeper_hand()
	# Draw four cards
	_pick_player_hand()

	# We really need to learn finite state machines
	_in_battle = true

	# Avoid initial misclicks as we don't have a proper screen transition
	_activate_cooldowns()


func _on_change_button_pressed():
	var index: int
	var card: Card
	var slot: CardSlot
	var selection_size: int = selected_cards.size()

	# TODO store burned cards for the end screen
	EventBusGame.summary_update_burned_cards.emit(selected_cards)

	# Destroy selected cards
	card = null
	for i: int in selection_size:

		# Destroy card and free up slot
		_clear_slot(selected_cards[i].index + 1)

		# Remove card from player's hand
		player_hand.remove_at( player_hand.find(selected_cards[i]) )

	# Remove cards from selection
	selected_cards.clear()

	# Update player hand indexes
	index = -1
	card = null
	slot = null
	for i: int in player_hand.size():

		# Index mismatch: card's internal index and hand index are not the same anymore
		if player_hand[i].index != i:
			# Remove card from current slot
			card = get_node("PlayerHand/CardSlot%s" % (player_hand[i].index + 1)).remove_card()

			# Move card in first empty slot
			for j: int in range(4):
				slot = get_node("PlayerHand/CardSlot%s" % (j + 1))
				if slot.is_empty():
					assert(i == j, "BattleManager: critical error while updating player's hand indexes")
					slot.add_card(card)
					player_hand[i].index = j
					break

	# Draw replacement cards
	index = -1
	card = null
	slot = null
	for i: int in selection_size:

		# Draw random card from the deck
		index = randi() % player_deck.size()
		card = player_deck[index]

		# Place new card in the first available empty slot
		for j: int in range(4):
			slot = get_node("PlayerHand/CardSlot%s" % (j + 1))
			if slot.is_empty():
				card.index = j
				slot.add_card(card)
				player_hand.append(card)
				player_deck.remove_at(index)

	_deselect_card_slots()
	# Update available changes
	available_changes -= 1
	%AvailableBurnLabel.text = "%d" % available_changes


func _on_confirm_button_pressed():
	# TODO store used cards
	EventBusGame.summary_update_used_cards.emit(selected_cards)
	EventBusGame.summary_update_total_items_cost.emit(shopkeeper_hand_left.value + shopkeeper_hand_right.value)

	# Destroy selected cards
	var index: int = -1
	var selection_size: int = selected_cards.size()
	for i: int in selection_size:

		# Remove card from player hand
		player_hand.remove_at( player_hand.find(selected_cards[i]) )

		# Remove card from CardSlot
		_clear_slot(selected_cards[i].index + 1)
	selected_cards.clear()

	# Destroy shopkeeper cards
	%CardSlotLeft.remove_card()
	%CardSlotRight.remove_card()
	shopkeeper_hand_left.queue_free()
	shopkeeper_hand_right.queue_free()

	# Put unused cards from player hand back into the deck
	for i: int in player_hand.size():
		player_deck.append(player_hand[i])
	player_hand.clear()
	EventBusGame.deck_update.emit(player_deck)

	# Reset slots selection
	_deselect_card_slots()

	# Destroy item
	%ItemDisplay.remove_child(item_on_display)
	item_on_display.queue_free()

	# Go back to market scene
	_in_battle = false
	EventBusGame.battle_end.emit(true)


func _activate_cooldowns():
	for i: int in range(4):
		(get_node("PlayerHand/CardSlot%s" % (i + 1)) as CardSlot)._click_cooldown.start()


func _calculate_sum(cards: Array[Card]):
	var count: int = 0
	for card: Card in cards:
		count += card.value
	return count


func _clear_slot(slot_index: int):
	var card = get_node("PlayerHand/CardSlot%s" % slot_index).remove_card()
	card.queue_free()


func _deselect_card_slots():
	var slot: CardSlot
	for i: int in range(4):
		slot = get_node("PlayerHand/CardSlot%s" % (i + 1))
		slot.selected = false
		slot._on_area_2d_mouse_exited()


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
