extends PanelContainer

@onready var ClientPack = preload("res://UI/Elements/client_button.tscn")

func spawn_client():
	var new_client =  ClientPack.instantiate()
	%ClientsGrid.add_child(new_client)
	new_client.setup('hard')


func _on_spawn_timer_timeout() -> void:
	spawn_client()
	%SpawnTimer.start(10)

