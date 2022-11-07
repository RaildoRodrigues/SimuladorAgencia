extends CanvasLayer



func change_scene(new_scene : String) -> void:
	var anim = get_node("Tex/Anim")
	anim.play('fadeout')
	await anim.animation_finished
	get_tree().change_scene_to_packed(load(new_scene))
	anim.play('fadein')
