extends Control

var data : Dictionary = {}
var end_drag : String = 'return_to_slot'

signal draged_out

func update_drag_display(new_data):
	data = new_data
	if data.item:
		%tex_icon.texture = data.item.texture
		if data.item.amount > 1:
			%lb_amount.text = str(data.item.amount)
		else:
			%lb_amount.text = ""
	else:
		%tex_icon.texture = null
		%lb_amount.text = ""

func return_to_slot(data):
	if data and data.can_return:
		data.inventory.add_item(data.item_index, data.item)
#		print('item raplaced in ', data.inventory.code, '[', data.item_index, ']')

func return_to_client(data):
	if data and data.can_return:
		data.original_client.add_item(data.item)

func _exit_tree() -> void:
	call(end_drag, data)