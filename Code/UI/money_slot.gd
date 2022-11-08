extends ItemContainer



func _can_drop_data(_at_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("item") and data.item.category == 'money'

func  _drop_data(at_position: Vector2, data) -> void:
	%SFXPlayer.play_drop_sound()
	super(at_position,data)
	
func _grab_all_data() -> void:
	if my_item : %SFXPlayer.play_drag_sound()
	super()
	
func _get_drag_data(_at_position: Vector2):
	if my_item : %SFXPlayer.play_drag_sound()
	return super(_at_position)
