extends PanelContainer

@onready var ClientPack = preload("res://UI/Elements/client_button.tscn")

func spawn_client():
	var new_client =  ClientPack.instantiate()
	var stress_ometer = get_tree().get_first_node_in_group('main_stress_bar')
	new_client.connect('stressfull', stress_ometer.stress)
	%ClientsGrid.add_child(new_client)
	new_client.setup('random', 'random', generate_random_wallet('random'))


func _on_spawn_timer_timeout() -> void:
	spawn_client()
	spawn_client()
	%SpawnTimer.start(10)


func generate_wallet(_amount) -> Array:
	var wallet = []
	while _amount >= 0:
		if _amount - 100 > 0:
			wallet.append(100)
			_amount -= 100
		elif _amount - 50 > 0:
			wallet.append(50)
			_amount -= 50
		elif _amount - 20 > 0:
			wallet.append(20)
			_amount -= 20
		elif _amount - 10 > 0:
			wallet.append(10)
			_amount -= 10
		elif _amount - 5 > 0:
			wallet.append(5)
			_amount -= 5
		elif _amount - 2 > 0:
			wallet.append(2)
			_amount -= 2
	return wallet

func generate_random_wallet(difficult) -> Array:
	var difficulties = ['easy','normal','hard','extreme']
	if not difficulties.has(difficult):
		difficult = difficulties[randi_range(0,3)]
		print('new difficult is: ', difficult)
	var wallet = []
	if randf() <= 0.1: wallet.append(200)
	var notas_100 = randi_range(1, 5)
	for notas in range(notas_100):
		wallet.append(100)
	if difficult == 'normal' or difficult == 'hard' or difficult == 'extreme':
		var notas_50 = randi_range(0, 4)
		var notas_20 = randi_range(0, 2)
		for notas in range(notas_50):
			wallet.append(50)
		for notas in range(notas_20):
			if randf() <= 0.25: wallet.append(20)
	if difficult == 'hard' or difficult == 'extreme':
		var notas_20 = randi_range(0, 2)
		var notas_10 = randi_range(0, 2)
		var notas_05 = randi_range(0, 2)
		for notas in range(notas_20):
			wallet.append(20)
		for notas in range(notas_10):
			wallet.append(10)
		for notas in range(notas_05):
			if randf() <= 0.25: wallet.append(5)

	if difficult == 'extreme':
		var notas_05 = randi_range(0, 2)
		var notas_02 = randi_range(0, 2)
		for notas in range(notas_05):
			wallet.append(5)
		for notas in range(notas_02):
			wallet.append(2)
		if randf() <= 0.25: wallet.shuffle()
		if randf() <= 0.5: wallet.append(200)
	return wallet
	
func wallet_sum(wallet : Array) -> int:
	var total := 0
	for _money in wallet:
		total += _money
	return total
