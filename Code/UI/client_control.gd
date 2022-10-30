extends Control


var drag_preview_prefab = preload("res://UI/Elements/drag_preview.tscn")

#editables
var difficult := 'normal'
var category := 'random'
var value := 0
var potrait := 'generate'
var events := []

#Atributesx
var money : Array = []
var stress : float = 0:
	get:
		return stress
	set(_number):
		stress = _number
		%stressbar.value = _number
		if _number >= 100 : emit_signal('stressfull')
#signals
signal stressfull



func setup(_difficult : String = difficult, _category : String = category, _value : int = value ) -> void:
	difficult = _difficult
	category = _category
	value = _value
	if category == 'random': 
		category = choose(['deposit'])
		setup()
	else:
		intro_animation()
		match category:
			'deposit':
				bank_client_deposit_setup()
				
	

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

func reset():
	%Interact.disabled = true

func call_event():
	reset()
	var event = events.pop_front()
	if event:
		print('prox')
	else:
		exit_agency()


func exit_agency():
	var final_color = Color.TRANSPARENT
	modulate = Color.WHITE 
	var anim_tween = create_tween()
	anim_tween.connect('finished', queue_free)
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(self, 'modulate', final_color, 0.5)
	



#########DEPOSIT FUNCTIONS#####################
	
func bank_client_deposit_setup():
	#setup button
	%Interact.disabled = false
	#setup icon
	#setup value
	if value == 0:
		generate_random_money()
	else:
		gemerate_money()
	update_money_display()

func generate_random_money():
	var notas_100 = randi_range(1, 5)
	for notas in range(notas_100):
		money.append(100)
	if difficult == 'normal' or difficult == 'hard':
		var notas_50 = randi_range(0, 4)
		for notas in range(notas_50):
			money.append(50)
	if difficult == 'hard':
		var notas_20 = randi_range(0, 3)
		for notas in range(notas_20):
			money.append(20)
			
func gemerate_money():
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
	for _cedula in money:
		total += _cedula
	return total

func _on_interact_button_down() -> void:
	create_drag_cedula()
	
func create_drag_cedula():
	var cedula = money.pop_front()
	if cedula == 100:
			cedula = preload("res://Code/Resources/Database/cedula_cem.tres").duplicate()
	elif cedula == 50:
			cedula = preload("res://Code/Resources/Database/cedula_cin.tres").duplicate()
	elif cedula == 20:
			cedula = preload("res://Code/Resources/Database/cedula_vin.tres").duplicate()
	else:
			stress += 20
			return
			
	await get_tree().create_timer(0.01).timeout
	var data = {}
	data.item = cedula
	data.item.amount = 1
	data.original_client = self
	data.can_return = true
	data.item.connect('droped', my_cedula_droped)
	var drag_preview = drag_preview_prefab.instantiate()
	drag_preview.update_drag_display(data)
	drag_preview.end_drag = 'return_to_client'
	force_drag(data, drag_preview)
	update_money_display()
	
func my_cedula_droped(_slot):
	if money.is_empty():
		call_event()

func add_item(item):
	if item is Item:
		if item.category == 'money' : stress += 30
		for i in range(item.amount):
			money.append(item.value)
		update_money_display()

func update_money_display():
	%lb_value.text = str(get_total_money())
