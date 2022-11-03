class_name Item extends Resource

var my_inventory : InventoryContainer

signal picked(picked_slot : ItemContainer)
signal droped(droped_slot : ItemContainer)


@export_category('Item Identification')
@export_placeholder('Item Name') var code : String
@export var texture : Texture2D
@export var category : String #(money, product)
@export_subgroup('Financial')
@export var amount : int = 1
@export_range(0 , 200, 0.25) var value : float = 0


