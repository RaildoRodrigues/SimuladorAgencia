extends Control

#ARTS
var drag_preview_prefab = preload("res://UI/Elements/drag_preview.tscn")
var deposit_icon = preload("res://Art/Icons/deposit_icon.tres")
var withdraw_icon = preload("res://Art/Icons/withdraw_icon.tres")
var frames = {'doc' : preload("res://Art/Theme/client_DOC.theme"),
				'rg': preload("res://Art/Theme/client_RG.theme"),
				'papper' : preload("res://Art/Theme/client_PAP.theme")}


#editables
var category = 'random'
var difficult = 'random'
var value = [100]
var potrait = 'generate'
var events = []
var passive_stress = 5


var client_configs = {
	difficult = difficult,
	category = category,
	value = value,
	potrait = potrait,
	events = events,
	passive_stress = passive_stress
}


#Atributesx
var money : Array = []
var withdraw_value = 0
var stress : float = 0:
	get:
		return stress
	set(_number):
		stress = _number
		%stressbar.value = _number
		%Anim.stop()
		%Anim.play('stress')
		%stressbar.modulate = lerp(Color.ORANGE, Color.RED, _number /100)
		%SFXPlayer.play_zombie_sound()
		if _number >= 100 : emit_signal('stressfull')
var can_drop_money = false
var can_pick_money = false

#signals
signal stressfull(stress_amount)
signal dispached
signal loss_money(amount)


func setup(_client_configs = client_configs) -> void:
	client_configs.merge(_client_configs, true)
	difficult = client_configs.difficult
	category =client_configs.category
	value = client_configs.value
	potrait = client_configs.potrait
	events = client_configs.events
	passive_stress = client_configs.passive_stress
	intro_animation()
	
	if category == 'random' : category = choose(['deposit', 'withdraw'])
	match category:
		'deposit':
			theme = frames.papper
			bank_client_deposit_setup()
		'withdraw':
			theme = choose([frames.rg,frames.rg,frames.rg,frames.rg, frames.doc])
			bank_client_withdraw_setup()
				
	

##########SUPORT FUNCTIONS###############
	
func choose(array : Array):
	var random_array = array.duplicate()
	random_array.shuffle()
	return random_array[0]

func _on_stress_timer_timeout() -> void:
	if stress >= 100:
		%Anim.stop()
		%Anim.play('stress')
		emit_signal('stressfull')
		
func _on_wait_timer_timeout() -> void:
	stress += passive_stress
	%WaitTimer.start(3)
	
func intro_animation():
	var start_color = Color.WHITE
	modulate = Color.TRANSPARENT
	var anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(self, 'modulate', start_color, 0.5)

func reset():
	can_pick_money = false
	can_drop_money = false

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
	emit_signal('dispached')
	



#########DEPOSIT FUNCTIONS#####################
	
func bank_client_deposit_setup():
	#setup button
	can_pick_money = true
	#setup icon
	%tex_icon.texture = deposit_icon
	#setup value
	money = value.duplicate()
	update_money_display()



func get_total_money() -> int:
	var total := 0
	for _cedula in money:
		total += _cedula
	return total

func _on_interact_button_down() -> void:
	if can_pick_money : create_drag_cedula()
	
func create_drag_cedula():
	%SFXPlayer.play_drag_sound()
	var cedula = money.pop_front()
	if cedula == 100:
			cedula = preload("res://Code/Resources/Database/cedula_cem.tres").duplicate()
	elif cedula == 50:
			cedula = preload("res://Code/Resources/Database/cedula_cin.tres").duplicate()
	elif cedula == 20:
			cedula = preload("res://Code/Resources/Database/cedula_vin.tres").duplicate()
	elif cedula == 10:
			cedula = preload("res://Code/Resources/Database/cedula_dez.tres").duplicate()
	elif cedula == 5:
			cedula = preload("res://Code/Resources/Database/cedula_cinc.tres").duplicate()
	elif cedula == 2:
			cedula = preload("res://Code/Resources/Database/cedula_doi.tres").duplicate()
	elif cedula == 200:
			cedula = preload("res://Code/Resources/Database/cedula_duz.tres").duplicate()
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
		if item.category == 'money' :
			stress += 30
		for i in range(item.amount):
			money.append(item.value)
		update_money_display()

func update_money_display():
#	%lb_value.text = str(get_total_money())
	%lb_value.text = "%03d" % get_total_money()

##############WITHDRAW FUNCTIONS################

func bank_client_withdraw_setup():
	#setup icon
	%tex_icon.texture = withdraw_icon
	#setup value
	can_drop_money = true
	money = value.duplicate()
	update_money_display()
	withdraw_value = get_total_money()
	
func _can_drop_data(_at_position: Vector2, data) -> bool:
	if category == 'withdraw':
		return typeof(data) == TYPE_DICTIONARY and data.has("item") and data.item.category == 'money'
	else:
		return false
	
func _drop_data(_at_position: Vector2, data) -> void:
	data.can_return = false
	if category == 'withdraw':
		%SFXPlayer.play_drop_sound()
		withdraw_value -= data.item.value * data.item.amount
		data.item.emit_signal('droped', null)
		%lb_value.text = "%03d" % withdraw_value
		%Anim.stop()
		%Anim.play('great')
		if withdraw_value <= 0:
			call_event()
		if withdraw_value < 0:
			emit_signal('loss_money', withdraw_value)
			emit_signal('stressfull', max(abs(withdraw_value/10), 1))
	
	
