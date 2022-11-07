extends CanvasLayer


var level_data : Dictionary = {pool = [], gaveta = [], interval = 10}

func change_to_menu(menu : String):
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	await anim.animation_finished
	get_tree().change_scene_to_packed(load(menu))
	anim.play('fadein')
	
func change_to_level(_pool, _gaveta, _interval):
	level_data.pool = _pool
	level_data.gaveta = _gaveta
	level_data.interval = _interval
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	await anim.animation_finished
	get_tree().change_scene_to_packed(preload("res://UI/Pages/MainUI.tscn"))
	anim.play('fadein')
