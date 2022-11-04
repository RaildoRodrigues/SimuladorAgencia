extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bt_hide_clients_button_up() -> void:
	if %ClientPanel.visible:
		%ClientPanel.visible = false
	else:
		%ClientPanel.visible = true


func _on_bt_hide_gaveta_toggled(button_pressed: bool) -> void:
	%GavetaPanel.visible = button_pressed
