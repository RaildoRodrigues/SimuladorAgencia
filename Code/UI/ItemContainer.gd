class_name ItemContainer extends PanelContainer


const LOG = false
func debug(text : String):
	if LOG : print(text)

@export_node_path(TextureRect) var tex_icon_path
@export_node_path(Label) var lb_amount_path
@export_node_path(Button) var bt_grab_path

@onready var tex_icon : TextureRect = get_node(tex_icon_path)
@onready var lb_amount : Label = get_node(lb_amount_path)
@onready var bt_grab : Button = get_node(bt_grab_path)

var drag_preview_prefab = preload("res://UI/Elements/drag_preview.tscn")
var inventory : InventoryContainer
var can_grab_all = true

var slot_name : String:
	get:
		return inventory.code + '[' + str(get_index()) + ']' 

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
	var item_index = get_index()
	var item = inventory.remove_item(item_index, true)
	debug(slot_name + ' moved')
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.inventory = inventory
		data.original_slot = self
		data.can_return = true
		data.remain = 0
		var drag_preview = drag_preview_prefab.instantiate()
		drag_preview.update_drag_display(data)
		force_drag(data, drag_preview)



func _get_drag_data(at_position: Vector2):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	debug(slot_name + ' moved')
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.inventory = inventory
		data.original_slot = self
		data.can_return = true
		data.remain = inventory.item_list[item_index]
		if data.remain:
			data.remain = data.remain.amount
		else:
			data.remain = 0
		var drag_preview = drag_preview_prefab.instantiate()
		drag_preview.update_drag_display(data)
		set_drag_preview(drag_preview)
		return data
	
	
func _drop_data(at_position: Vector2, data) -> void:
	data.can_return = false
	var index = get_index()
	var item = inventory.item_list[index]
	if item is Item and item.code == data.item.code:
		item.amount += data.item.amount
		update_slot_display(item)
		debug('+' + data.item.amount + 'added in ' + slot_name)
	elif data.has('inventory'):
		if item and data.item: data.item.amount += data.remain
		data.inventory.add_item(data.item_index, item)
		inventory.add_item(index, data.item)
		debug(slot_name + ' swaped with ' + data.inventory.code + '[' + str(data.item_index) + ']' )
	elif data.has('original_client'):
		inventory.add_item(index, data.item)
		data.original_client.add_item(item)

func _can_drop_data(at_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("item")
	
	
	
	
	
	
