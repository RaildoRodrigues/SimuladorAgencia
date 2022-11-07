extends ProgressBar


func stress(amount : float = 10.0):
	var new_amount = value + amount
	var anim_tween = create_tween()
	anim_tween.set_ease(Tween.EASE_IN)
	anim_tween.tween_property(self, 'value', new_amount, 0.3)
	%Anim.stop()
	%Anim.play('redAlert')
	print('stress aded +', amount)
