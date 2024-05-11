class_name ItemSlot extends Node2D

const DEFAULT_SCALE = Vector2.ONE
const HIGHLIGHT_SCALE = Vector2(1.5, 1.5)

@export
var index: int = -1

@onready
var _click_cooldown: Timer = $ClickCooldown

var _item: Item

func _ready():
	assert(index != -1, "ItemSlot index is -1")

func put_item(item: Item):
	_item = item
	$ItemContainer.add_child(_item)
	_item.position = $ItemContainer.position

func take_item():
	# TODO TEST ME
	var item: Item = _item
	$ItemContainer.remove_child(_item)
	_item = null
	return item

func _on_area_2d_mouse_entered():
	if _item:
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($ItemContainer, "scale", HIGHLIGHT_SCALE, 0.2)

func _on_area_2d_mouse_exited():
	if _item:
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property($ItemContainer, "scale", DEFAULT_SCALE, 0.2)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !_click_cooldown.is_stopped():
		return
	if event is InputEventMouseButton:
		EventBusGame.item_select.emit(index)
		_click_cooldown.start()
