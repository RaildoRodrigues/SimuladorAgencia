extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_level_icon()
	update_stress_bar()
	update_time_label()


func update_time_label():
	var minutes = (Game.level_time / 60) % 60
	var seconds = Game.level_time % 60
	var time = "%02d:%02d" % [minutes, seconds]
	%time.text = time
	print(time)

func update_stress_bar():
	%stressbar.value = Game.level_stress
	
func update_level_icon():
	%lb_day.text = Game.level_name


func _on_bt_return_button_up() -> void:
	%SFX.play()
	Game.change_to_menu("res://UI/Pages/level_menu.tscn")
