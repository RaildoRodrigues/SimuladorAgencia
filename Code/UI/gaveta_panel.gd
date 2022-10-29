extends InventoryContainer


func _ready() -> void:
	item_list = [preload("res://Code/Resources/Database/cedula_cin.tres"),null,null,null,null,null,]
	start_inventory()


