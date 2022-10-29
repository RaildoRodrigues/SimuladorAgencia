extends ItemContainer


func _can_drop_data(at_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("item") and data.item.category == 'money'


