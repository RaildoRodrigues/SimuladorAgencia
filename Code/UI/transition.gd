extends CanvasLayer



func change_scene(new_scene : String) -> void:
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	await anim.animation_finished
	get_tree().change_scene_to_packed(load(new_scene))
	anim.play('fadein')

func load_level(_pool, _gaveta = [], _interval = 10.0):
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	await anim.animation_finished
	get_tree().change_scene_to_packed(preload("res://UI/Pages/new_level.tscn"))
	var new_level = get_tree().get_first_node_in_group('new_level')
	new_level.change_to_level(_pool, _gaveta, _interval)
	
