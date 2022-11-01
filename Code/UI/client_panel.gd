extends PanelContainer

@onready var ClientPack = preload("res://UI/Elements/client_button.tscn")

func spawn_client():
	var new_client =  ClientPack.instantiate()
	var stress_ometer = get_tree().get_first_node_in_group('main_stress_bar')
	new_client.connect('stressfull', stress_ometer.stress)
	%ClientsGrid.add_child(new_client)
	new_client.setup('easy')


func _on_spawn_timer_timeout() -> void:
	spawn_client()
	%SpawnTimer.start(10)

