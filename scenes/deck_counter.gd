extends MarginContainer

@onready
var _available_slots: Label = %AvailableSlots

@onready
var _total_slots: Label = %TotalSlots

func _ready():
	EventBusUi.update_deck_counter.connect(_on_update_deck_counter)

func _on_update_deck_counter(available: int, total: int):
	_available_slots.text = "%d" % available
	_total_slots.text = "%d" % total
