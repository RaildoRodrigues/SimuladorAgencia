extends InventoryContainer



func clear_gaveta():
	for item in item_grid.get_children():
		item_list.append(null)
	start_inventory()


func set_gaveta(wallet_amounts : Array):
	clear_gaveta()
	var cedulas = []
	cedulas.append(preload("res://Code/Resources/Database/cedula_cem.tres").duplicate())
	cedulas.append(preload("res://Code/Resources/Database/cedula_cin.tres").duplicate())
	cedulas.append(preload("res://Code/Resources/Database/cedula_vin.tres").duplicate())
	cedulas.append(preload("res://Code/Resources/Database/cedula_dez.tres").duplicate())
	cedulas.append(preload("res://Code/Resources/Database/cedula_cinc.tres").duplicate())
	cedulas.append(preload("res://Code/Resources/Database/cedula_doi.tres").duplicate())
	for i in range(wallet_amounts.size()):
		if wallet_amounts[i] > 0:
			item_list[i] = cedulas[i]
			item_list[i].amount = wallet_amounts[i]
		else:
			item_list[i] = null
	start_inventory()
