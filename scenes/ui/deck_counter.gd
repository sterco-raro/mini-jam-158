extends MarginContainer

@onready
var _available_slots: Label = %AvailableSlots
@onready
var _total_slots: Label = %TotalSlots


func _ready():
	EventBusUi.deck_ui_update.connect(_on_deck_ui_update)


func _on_deck_ui_update(available: int, total: int):
	_available_slots.text = "%d" % available
	_total_slots.text = "%d" % total
