extends ProgressBar


func stress(amount : float = 5.0):
	var new_amount = value + amount
	var anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(self, 'value', new_amount, 0.3)
	%Anim.stop()
	%Anim.play('redAlert')
	%SFX.play()
	if value >= 100:
		Game.level_stress = value
		Game.change_to_menu("res://UI/Pages/defeat_screen.tscn")

