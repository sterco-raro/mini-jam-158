class_name CardSlot extends Node2D

@export
var PLAYER_OWNED: bool = false

var card: Card

@onready
var _container: Node2D = $Container

@onready
var _click_cooldown: Timer = $ClickCooldown

var _original_position: Vector2
var _tween_target_position: Vector2

func _ready():
	_original_position = _container.position
	_tween_target_position = _container.position + Vector2.UP * 10

func _on_area_2d_mouse_entered():
	if PLAYER_OWNED and card:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(_container, "position", _tween_target_position, 0.2)

func _on_area_2d_mouse_exited():
	if PLAYER_OWNED and card:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(_container, "position", _original_position, 0.2)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !_click_cooldown.is_stopped():
		return
	if event is InputEventMouseButton:
		EventBusGame.battle_card_select.emit(card)
		_click_cooldown.start()
