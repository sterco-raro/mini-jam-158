class_name CardSlot extends Node2D

@export
var PLAYER_OWNED: bool = false

var card: Card
var selected: bool = false

var _original_position: Vector2
var _tween_target_position: Vector2

@onready
var _container: Node2D = $Container

@onready
var _click_cooldown: Timer = $ClickCooldown


func _ready():
	_original_position = position
	_tween_target_position = position + Vector2.UP * 32


func add_card(_card: Card):
	if card == null:
		card = _card
		if card.get_parent():
			card.reparent(_container)
		else:
			_container.add_child(card)


func is_empty():
	return card == null


func remove_card():
	var _card: Card = card
	if _card:
		_container.remove_child(_card)
	card = null
	selected = false
	_on_area_2d_mouse_exited()
	return _card


func _on_area_2d_mouse_entered():
	if !PLAYER_OWNED or !card or selected:
		return
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", _tween_target_position, 0.2)


func _on_area_2d_mouse_exited():
	if !PLAYER_OWNED or !card or selected:
		return
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", _original_position, 0.2)


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !card:
		return
	if !_click_cooldown.is_stopped():
		return
	if event is InputEventMouseButton:
		EventBusGame.battle_card_select.emit(card)
		selected = not selected
		_click_cooldown.start()
