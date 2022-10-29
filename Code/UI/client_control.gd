extends Control

const LOG = false
func debug(text : String):
	if LOG : print(text)

var money : Array = []
var drag_preview_prefab = preload("res://UI/Elements/drag_preview.tscn")

func setup(difficult : String = 'normal', category : String = 'random' ,value : int = 0):
	if category == 'random': 
		var random_category = choose(['deposit'])
		setup(difficult, random_category, value)
	else:
		intro_animation()
		match category:
			'deposit':
				bank_client_deposit_setup(difficult, value)
				debug('generate a deposit client ' + difficult.to_upper() + ' difficult with ' + str(get_total_money()) + ' money'  )
	

##########SUPORT FUNCTIONS###############
	
func choose(array : Array):
	var random_array = array.duplicate()
	random_array.shuffle()
	return random_array[0]

	
func intro_animation():
	var start_color = Color.WHITE
	modulate = Color.TRANSPARENT
	var anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(self, 'modulate', start_color, 0.5)
	
#########DEPOSIT FUNCTIONS#####################
	
func bank_client_deposit_setup(difficult, value : int):
	#setup button
	%Interact.disabled = false
	#setup icon
	#setup value
	if value == 0:
		generate_random_money(difficult)
	else:
		gemerate_money(value)
	update_money_display()

func generate_random_money(difficult):
	var notas_100 = randi_range(1, 5)
	for notas in range(notas_100):
		money.append(100)
	if difficult == 'normal' or difficult == 'hard':
		var notas_50 = randi_range(1, 5)
		for notas in range(notas_50):
			money.append(50)
	if difficult == 'hard':
		var notas_20 = randi_range(1, 5)
		for notas in range(notas_20):
			money.append(20)
			
func gemerate_money(value):
	while true:
		if value - 100 >= 0:
			money.append(100)
			value -= 100
		elif value - 50 >= 0:
			money.append(50)
			value -= 50
		elif  value - 20 >= 0:
			money.append(20)
			value -= 20
		else:
			break

func get_total_money() -> int:
	var total := 0
	for value in money:
		total += value
	return total

func _on_interact_button_down() -> void:
	create_drag_cedula()
	
func create_drag_cedula():
	var cedula = money.pop_back()
	if cedula == 100:
			cedula = preload("res://Code/Resources/Database/cedula_cem.tres").duplicate()
	elif cedula == 50:
			cedula = preload("res://Code/Resources/Database/cedula_cin.tres").duplicate()
	elif cedula == 20:
			cedula = preload("res://Code/Resources/Database/cedula_vin.tres").duplicate()
	else:
			print('ERR:', cedula)
			return
	await get_tree().create_timer(0.01).timeout
	var data = {}
	data.item = cedula
	data.item.amount = 1
	data.original_client = self
	data.can_return = true
	var drag_preview = drag_preview_prefab.instantiate()
	drag_preview.update_drag_display(data)
	drag_preview.end_drag = 'return_to_client'
	force_drag(data, drag_preview)
	update_money_display()
	
func add_item(item):
	if item is Item:
		for i in range(item.amount):
			money.append(item.value)
		update_money_display()

func update_money_display():
	%lb_value.text = str(get_total_money())
