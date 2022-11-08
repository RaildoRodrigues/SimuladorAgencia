extends CanvasLayer


var level_data : Dictionary = {pool = [], gaveta = [], interval = 10}
var tip
var level_name = 0
var level_stress = 0
var level_time = 0
var level_tip = ''
var scores = {}



func show_confirm():
	update_records()
	%lb_day.text = level_name
	for child in %Tip.get_children():
		child.queue_free()
	if level_tip != '':
		tip = load(level_tip)
		tip = tip.instantiate()
		%Tip.add_child(tip)

func update_records():
	if scores.has(level_name):
		%stressbar.visible = true
		%stressbar.value = scores[level_name].stress
		%time.visible = true
		var minutes = (scores[level_name].time / 60) % 60
		var seconds = scores[level_name].time % 60
		var time = "%02d:%02d" % [minutes, seconds]
		%time.text = time
	else:
		%time.visible = false
		%stressbar.visible = false


func change_to_menu(menu : String):
	%ConfirmPanel.visible = false
	var anim = get_node("Tex/Anim")
	anim.play('fadein')
	await anim.animation_finished
	get_tree().change_scene_to_packed(load(menu))
	anim.play('fadeout')

	
func change_to_level(_pool, _gaveta, _interval):
	level_data.pool = _pool
	level_data.gaveta = _gaveta
	level_data.interval = _interval
	var anim = get_node("Tex/Anim")
	anim.play('fadein')
	%ConfirmPanel.visible = true
	



func _on_bt_confirm_button_up() -> void:
	var anim = get_node("Tex/Anim")
	get_tree().change_scene_to_packed(preload("res://UI/Pages/MainUI.tscn"))
	anim.play('fadeout')
	%ConfirmPanel.visible = false


func _on_bt_return_button_up() -> void:
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	%ConfirmPanel.visible = false
