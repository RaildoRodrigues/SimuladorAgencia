class_name ItemContainer extends PanelContainer



var slot_name : String:
	get:
		return inventory.code + '[' + str(get_index()) + ']' 

@export_node_path(TextureRect) var tex_icon_path
@export_node_path(Label) var lb_amount_path
@export_node_path(Button) var bt_grab_path

@onready var tex_icon : TextureRect = get_node(tex_icon_path)
@onready var lb_amount : Label = get_node(lb_amount_path)
@onready var bt_grab : Button = get_node(bt_grab_path)

var drag_preview_prefab = preload("res://UI/Elements/drag_preview.tscn")
var inventory : InventoryContainer
var can_grab_all = true
var index : int:
	get:
		return get_index()
		
var my_item : Item:
	get:
		return inventory.item_list[index]

#SIGNALS



func _ready() -> void:
	bt_grab.connect('button_down', bt_grab_down)


func  bt_grab_down() -> void:
	await get_tree().create_timer(0.5).timeout
	if bt_grab.button_pressed and can_grab_all:
		if not get_viewport().gui_is_dragging():
			_grab_all_data()


func update_slot_display(item : Item):
	if item:
		tex_icon.texture = item.texture
		if item.amount > 0:
			lb_amount.text = str(item.amount)
		else:
			lb_amount.text = ""
	else:
		tex_icon.texture = null
		lb_amount.text = ""


func _grab_all_data() -> void:
	var item = inventory.remove_item(index, true)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = index
		data.inventory = inventory
		data.original_slot = self
		data.can_return = true
		data.remain = 0
		var drag_preview = drag_preview_prefab.instantiate()
		drag_preview.update_drag_display(data)
		item.emit_signal('picked', self)
		force_drag(data, drag_preview)



func _get_drag_data(_at_position: Vector2):
	var item = inventory.remove_item(index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = index
		data.inventory = inventory
		data.original_slot = self
		data.can_return = true
		data.remain = inventory.item_list[index]
		if data.remain:
			data.remain = data.remain.amount
		else:
			data.remain = 0
		item.emit_signal('picked', self)
		var drag_preview = drag_preview_prefab.instantiate()
		drag_preview.update_drag_display(data)
		set_drag_preview(drag_preview)
		return data
	
	
func _drop_data(_at_position: Vector2, data) -> void:
	data.can_return = false
	var item = inventory.item_list[index]
	if item is Item and item.code == data.item.code:
		item.amount += data.item.amount
		item.emit_signal('droped', self)
		update_slot_display(item)
	elif data.has('inventory'):
		if item and data.item: data.item.amount += data.remain
		data.inventory.add_item(data.item_index, item)
		inventory.add_item(index, data.item)
	elif data.has('original_client'):
		inventory.add_item(index, data.item)
		data.original_client.add_item(item)

func _can_drop_data(_at_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("item")
	
	
	
	
	
	
