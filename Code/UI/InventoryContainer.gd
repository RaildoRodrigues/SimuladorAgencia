class_name InventoryContainer extends PanelContainer

var item_list : Array = []
@export_node_path(Control) var item_grid_path
@export_placeholder('Inventory Name') var code
@onready var item_grid = get_node(item_grid_path)

func start_inventory():
	var order = 0
	for slot in item_list:
		add_item(order, slot)
		item_grid.get_child(order).inventory = self
		order += 1
		
func add_item(index : int, item : Item):
	item_list[index] = item
	item_grid.get_child(index).update_slot_display(item)
	
func remove_item(index) -> Item:
	var previous_item = item_list[index]
	item_list[index] = null
	item_grid.get_child(index).update_slot_display(null)
	return previous_item

