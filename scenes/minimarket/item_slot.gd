class_name ItemSlot extends Node2D

const DEFAULT_SCALE = Vector2.ONE
const HIGHLIGHT_SCALE = Vector2(1.5, 1.5)

@export
var index: int = -1

var _item: Item

@onready
var _click_cooldown: Timer = $ClickCooldown


func _ready():
	assert(index != -1, "ItemSlot index is -1")


func is_empty():
	return _item == null


func get_item_type() -> Constants.ITEMS:
	assert(!is_empty(), "ItemSlot: get_item_type on null item")
	return _item.type


func put_item(item: Item):
	if !_item:
		_item = item
		$ItemContainer.add_child(_item)
		_item.position = $ItemContainer.position


func take_item():
	if _item:
		var item: Item = _item
		$ItemContainer.remove_child(_item)
		_item = null
		return item
	return null


func _on_area_2d_mouse_entered():
	if _item:
		var tween = get_tree().create_tween()
		tween.tween_property($ItemContainer, "scale", HIGHLIGHT_SCALE, 0.2)


func _on_area_2d_mouse_exited():
	if _item:
		var tween = get_tree().create_tween()
		tween.tween_property($ItemContainer, "scale", DEFAULT_SCALE, 0.2)


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !_item:
		return
	if !_click_cooldown.is_stopped():
		return
	if event is InputEventMouseButton:
		EventBusGame.market_item_select.emit(index)
		_click_cooldown.start()
