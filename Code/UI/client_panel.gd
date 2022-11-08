extends PanelContainer


@onready var ClientPack = preload("res://UI/Elements/client_button.tscn")
@onready var gaveta = get_tree().get_first_node_in_group('gaveta')


var dispached_clients = 0
var client_pool : Array = []
var spawn_interval = 10.0



func _ready() -> void:
	Game.level_time = 0
	Game.level_stress = 0
	start_level()


func start_level():
	gaveta.set_gaveta(Game.level_data.gaveta)
	client_pool = Game.level_data.pool
	spawn_interval = Game.level_data.interval
	spawn_client()
	spawn_client()
	spawn_client()
	$VictoryTimer.start(1)
	


func create_client(client_config):
	var new_client =  ClientPack.instantiate()
	var stress_ometer = get_tree().get_first_node_in_group('main_stress_bar')
	new_client.connect('stressfull', stress_ometer.stress)
	new_client.connect('dispached', next_client)
	%ClientsGrid.add_child(new_client)
	new_client.setup(client_config)


func next_client():
	if not client_pool.is_empty():
		spawn_client()
		%SpawnTimer.start(spawn_interval)
		
func _on_victory_timer_timeout() -> void:
	if client_pool.is_empty() and %ClientsGrid.get_child_count() == 0:
		var stress_ometer = get_tree().get_first_node_in_group('main_stress_bar')
		Game.level_stress = stress_ometer.value
		Game.change_to_menu("res://UI/Pages/victory_screen.tscn")
	else:
		Game.level_time += 1
		%VictoryTimer.start(1)
	
	
func spawn_client():
	var new_client = client_pool.pop_back()
	if new_client:
		dispached_clients += 1
		create_client(new_client)
		%SpawnTimer.start(spawn_interval)




func _on_spawn_timer_timeout() -> void:
	spawn_client()
	%SpawnTimer.start(spawn_interval)




