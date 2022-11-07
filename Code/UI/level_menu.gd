extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bt_back_button_up() -> void:
	var main_level = "res://UI/Pages/start_menu.tscn"
	Transition.change_scene(main_level)
