extends InventoryContainer


func _ready() -> void:
	for item in item_grid.get_children():
		item_list.append(null)
	start_inventory()


