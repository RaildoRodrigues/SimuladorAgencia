extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level_icon()
	update_stress_bar()
	update_time_label()
	update_score()


func update_score():
	if Game.scores.has(Game.level_name):
		if Game.scores[Game.level_name].time >= Game.level_time:
			print('new time record')
			Game.scores[Game.level_name].time = Game.level_time
		if Game.scores[Game.level_name].stress >= Game.level_stress:
			print('new stress record')
			Game.scores[Game.level_name].stress = Game.level_stress
	else:
		var score = {}
		score.stress = Game.level_stress
		score.time = Game.level_time
		Game.scores[Game.level_name] = score
	

func update_time_label():
	var minutes = (Game.level_time / 60) % 60
	var seconds = Game.level_time % 60
	var time = "%02d:%02d" % [minutes, seconds]
	%time.text = time
	

func update_stress_bar():
	%stressbar.value = Game.level_stress
	
func update_level_icon():
	%lb_day.text = Game.level_name


func _on_bt_return_button_up() -> void:
	%SFX.play()
	Game.change_to_menu("res://UI/Pages/level_menu.tscn")
