class_name MarketManager extends Node2D

@export
var DECK: Deck

const ITEM_PREFABS: Array[PackedScene] = [
	preload("res://scenes/items/item_triangle.tscn"),
	preload("res://scenes/items/item_rectangle.tscn"),
	preload("res://scenes/items/item_circle.tscn")
]

const ITEM_SLOT_PREFAB: PackedScene = preload("res://scenes/minimarket/item_slot.tscn")
const ITEM_SLOT_QUANTITY: int = 18

var wishlist: Dictionary = {
	"Triangle": 0,
	"Rectangle": 0,
	"Circle": 0
}

var shopping_cart: Array[Item] = []

var items: Array[Item]
var slots: Array[ItemSlot]

var selected_slot: int = -1

@onready
var selection_highlight: Node2D = %SelectionHighlight

func _ready():
	EventBusGame.deck_empty.connect(_on_deck_empty)
	EventBusGame.item_select.connect(_on_item_select)
	EventBusGame.battle_end.connect(_on_battle_end)

	selection_highlight.visible = false

	_init_scene()

func _on_deck_empty():
	EventBusGame.game_end.emit()

func _on_item_select(index: int):
	selected_slot = index
	selection_highlight.position = slots[index].position
	selection_highlight.visible = true
	print("Selection highlight visible: %s" % selection_highlight.visible)
	print("Selection highlight position: %s" % selection_highlight.position)
	EventBusGame.battle_start.emit(slots[index]._item)

func _on_battle_end():
	var item: Item = slots[selected_slot].take_item()
	shopping_cart.append(item)
	selected_slot = -1
	item.visible = false
	selection_highlight.visible = false

func _init_scene():
	# Get total deck value
	var budget: int = 0
	for card: Card in DECK.cards_list:
		budget += card.value

	# Generate random items
	for i in ITEM_SLOT_QUANTITY:
		items.append(ITEM_PREFABS.pick_random().instantiate())

	_generate_and_fill_itemslots()
	_generate_wishlist(budget)

func _generate_and_fill_itemslots():
	var slot: ItemSlot
	var slot_node: Node2D = $Slots

	# TOP LEFT
	# 1
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[0])
	slot.index = 0
	slot.position = Vector2(-180, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 2
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[1])
	slot.index = 1
	slot.position = Vector2(-120, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 3
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[2])
	slot.index = 2
	slot.position = Vector2(-60, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# TOP RIGHT
	# 4
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[3])
	slot.index = 3
	slot.position = Vector2(60, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 5
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[4])
	slot.index = 4
	slot.position = Vector2(120, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 6
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[5])
	slot.index = 5
	slot.position = Vector2(180, -240)
	slots.append(slot)
	$Slots.add_child(slot)
	# BOTTOM LEFT
	# 7
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[6])
	slot.index = 6
	slot.position = Vector2(-180, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 8
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[7])
	slot.index = 7
	slot.position = Vector2(-120, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 9
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[8])
	slot.index = 8
	slot.position = Vector2(-60, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# BOTTOM RIGHT
	# 10
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[9])
	slot.index = 9
	slot.position = Vector2(60, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 11
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[10])
	slot.index = 10
	slot.position = Vector2(120, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# 12
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[11])
	slot.index = 11
	slot.position = Vector2(180, 240)
	slots.append(slot)
	$Slots.add_child(slot)
	# RIGHT TOP
	# 13
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[12])
	slot.index = 12
	slot.position = Vector2(340, -180)
	slots.append(slot)
	$Slots.add_child(slot)
	# 14
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[13])
	slot.index = 13
	slot.position = Vector2(340, -120)
	slots.append(slot)
	$Slots.add_child(slot)
	# 15
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[14])
	slot.index = 14
	slot.position = Vector2(340, -60)
	slots.append(slot)
	$Slots.add_child(slot)
	# RIGHT BOTTOM
	# 16
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[15])
	slot.index = 15
	slot.position = Vector2(340, 60)
	slots.append(slot)
	$Slots.add_child(slot)
	# 17
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[16])
	slot.index = 16
	slot.position = Vector2(340, 120)
	slots.append(slot)
	$Slots.add_child(slot)
	# 18
	slot = ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[17])
	slot.index = 17
	slot.position = Vector2(340, 180)
	slots.append(slot)
	$Slots.add_child(slot)
	## Top left
	#slot.position = Vector2(-180, -240)
	#slot.position = Vector2(-120, -240)
	#slot.position = Vector2(-60, -240)
	## Top right
	#slot.position = Vector2(60, -240)
	#slot.position = Vector2(120, -240)
	#slot.position = Vector2(180, -240)
	## Bottom left
	#slot.position = Vector2(-180, 240)
	#slot.position = Vector2(-120, 240)
	#slot.position = Vector2(-60, 240)
	## Bottom right
	#slot.position = Vector2(60, 240)
	#slot.position = Vector2(120, 240)
	#slot.position = Vector2(180, 240)

func _generate_wishlist(budget: int):
	var item: Item
	var current_cost: int = 0
	var _items: Array[Item] = items.duplicate(true)
	while (_items.size() > 0):
		item = _items.pop_at( randi() % _items.size() ) as Item
		if current_cost + item.price > budget:
			break
		else:
			wishlist[item.type] += 1
			current_cost += item.price
