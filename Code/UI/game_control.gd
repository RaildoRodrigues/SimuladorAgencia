extends CanvasLayer


var level_data : Dictionary = {pool = [], gaveta = [], interval = 10}
var tip

func show_confirm(level_name, level_tip = ''):
	%lb_day.text = level_name
	var old_tip = get_node("Tex/ConfirmPanel/PopPup/MarginContainer/Elements/Tip")
	if old_tip : old_tip.queue_free()
	if level_tip != '':
		tip = load(level_tip)
		tip = tip.instantiate()
		%Elements.add_child(tip)

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
