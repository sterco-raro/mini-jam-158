class_name MarketManager extends Node2D

const _ITEM_SLOT_PREFAB: PackedScene = preload("res://scenes/minimarket/item_slot.tscn")
const _ITEM_SLOT_QUANTITY: int = 18

var items: Array[Item]
var slots: Array[ItemSlot]

var selected_slot: int = -1
var selected_item: Item = null

@onready
var _battle_container: Node2D = $BattleContainer

@onready
var _gui_canvas_layer: CanvasLayer = $MarketContainer/UI

@onready
var _market_container: Node2D = $MarketContainer


func _ready():
	EventBusGame.battle_end.connect(_on_battle_end)
	EventBusGame.market_item_select.connect(_on_market_item_select)

	_battle_container.visible = false

	# Generate random items
	var scene: PackedScene
	var keys: Array = Constants.PREFAB_ITEMS.keys()
	for i in _ITEM_SLOT_QUANTITY:
		scene = Constants.PREFAB_ITEMS[ keys.pick_random() ]
		items.append(scene.instantiate())

	_generate_and_fill_itemslots()
	_generate_wishlist()


func _on_battle_end(win: bool):
	if win:
		var item: Item = slots[selected_slot].take_item()

		EventBusGame.shopping_cart_add_item.emit(item.type)

		item.queue_free()
	selected_slot = -1

	# Destroy battle scene and update containers visibility
	var node: Node2D = _battle_container.get_child(0)
	_battle_container.remove_child(node)
	node.queue_free()
	_toggle_containers(false)


func _on_market_item_select(index: int):
	if !slots[index].is_empty():
		# Store selected item
		selected_slot = index

		# Set up battle scene and start new battle
		_battle_container.add_child(ScenesData.SCENE_03_BATTLE.instantiate())
		EventBusGame.battle_set_item.emit( slots[selected_slot].get_item_type() )
		_toggle_containers(true)
		EventBusGame.battle_start.emit()


func _generate_and_fill_itemslots():
	var slot: ItemSlot
	var slot_node: Node2D = %Slots

	# TOP LEFT
	# 1
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[0])
	slot.index = 0
	slot.position = Vector2(-180, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 2
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[1])
	slot.index = 1
	slot.position = Vector2(-120, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 3
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[2])
	slot.index = 2
	slot.position = Vector2(-60, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# TOP RIGHT
	# 4
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[3])
	slot.index = 3
	slot.position = Vector2(60, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 5
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[4])
	slot.index = 4
	slot.position = Vector2(120, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 6
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[5])
	slot.index = 5
	slot.position = Vector2(180, -240)
	slots.append(slot)
	slot_node.add_child(slot)
	# BOTTOM LEFT
	# 7
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[6])
	slot.index = 6
	slot.position = Vector2(-180, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 8
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[7])
	slot.index = 7
	slot.position = Vector2(-120, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 9
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[8])
	slot.index = 8
	slot.position = Vector2(-60, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# BOTTOM RIGHT
	# 10
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[9])
	slot.index = 9
	slot.position = Vector2(60, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 11
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[10])
	slot.index = 10
	slot.position = Vector2(120, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# 12
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[11])
	slot.index = 11
	slot.position = Vector2(180, 240)
	slots.append(slot)
	slot_node.add_child(slot)
	# RIGHT TOP
	# 13
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[12])
	slot.index = 12
	slot.position = Vector2(340, -180)
	slots.append(slot)
	slot_node.add_child(slot)
	# 14
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[13])
	slot.index = 13
	slot.position = Vector2(340, -120)
	slots.append(slot)
	slot_node.add_child(slot)
	# 15
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[14])
	slot.index = 14
	slot.position = Vector2(340, -60)
	slots.append(slot)
	slot_node.add_child(slot)
	# RIGHT BOTTOM
	# 16
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[15])
	slot.index = 15
	slot.position = Vector2(340, 60)
	slots.append(slot)
	slot_node.add_child(slot)
	# 17
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[16])
	slot.index = 16
	slot.position = Vector2(340, 120)
	slots.append(slot)
	slot_node.add_child(slot)
	# 18
	slot = _ITEM_SLOT_PREFAB.instantiate()
	slot.put_item(items[17])
	slot.index = 17
	slot.position = Vector2(340, 180)
	slots.append(slot)
	slot_node.add_child(slot)
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


func _generate_wishlist():
	var item_counters: Dictionary = {}
	# Calculate total item quantities
	for item: Item in items:
		if item.type in item_counters:
			item_counters[item.type] += 1
		else:
			item_counters[item.type] = 1
	# Generate a new wishlist
	EventBusGame.wishlist_randomize.emit(item_counters)


func _toggle_containers(show_battle: bool):
	if show_battle:
		_market_container.visible = false
		_gui_canvas_layer.visible = false
		_battle_container.visible = true
	else:
		_market_container.visible = true
		_gui_canvas_layer.visible = true
		_battle_container.visible = false
