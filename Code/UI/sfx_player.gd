extends Node



func play_drag_sound():
	var drag_sounds = [%SFX_drag1, %SFX_drag2]
	var selected_sound = drag_sounds[randi_range(0,1)]
	selected_sound.play()
	

func play_drop_sound():
	var drag_sounds = [%SFX_drop1, %SFX_drop2,%SFX_drop3,%SFX_drop4]
	var selected_sound = drag_sounds[randi_range(0,3)]
	selected_sound.play()

func play_zombie_sound():
	var drag_sounds = [%SFX_zombie1, %SFX_zombie2, %SFX_zombie3, %SFX_zombie4]
	var selected_sound = drag_sounds[randi_range(0,3)]
	selected_sound.play()
