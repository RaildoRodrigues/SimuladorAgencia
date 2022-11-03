extends PanelContainer


@onready var ClientPack = preload("res://UI/Elements/client_button.tscn")
@onready var gaveta = get_tree().get_first_node_in_group('gaveta')

signal clients_ended

var client_pool = []
var spawn_interval = 10

func _ready() -> void:
	start_level_1()


func start_level_1():
	gaveta.set_gaveta([8,7,6])
	client_pool = generate_bank_client_pool(4, 'easy', 2)
	client_pool += generate_bank_client_pool(1, 'normal')
	client_pool.shuffle()
	create_client(client_pool.pop_back())
	create_client(client_pool.pop_back())
	create_client(client_pool.pop_back())
	%SpawnTimer.start(spawn_interval)
	



func create_client(client_config):
	var new_client =  ClientPack.instantiate()
	var stress_ometer = get_tree().get_first_node_in_group('main_stress_bar')
	new_client.connect('stressfull', stress_ometer.stress)
	%ClientsGrid.add_child(new_client)
	new_client.setup(client_config)

func _on_spawn_timer_timeout() -> void:
	var new_client = client_pool.pop_back()
	if new_client:
		create_client(new_client)
		%SpawnTimer.start(spawn_interval)
	else:
		emit_signal('clients_ended')
	

func generate_bank_client_pool(_amount, _difficult, prop = 1) -> Array:
	var pool : Array = []
	var value_pools = generate_money_pool(_amount, _difficult, prop)
	var withdraw_pool = value_pools[0]
	var deposit_pool = value_pools[1]
	for wallet in withdraw_pool:
		var new_client = {}
		new_client.category = 'withdraw'
		new_client.value = wallet
		pool.append(new_client)

	for wallet in deposit_pool:
		var new_client = {}
		new_client.category = 'deposit'
		new_client.value = wallet
		pool.append(new_client)
	return pool


func generate_money_pool(_amount, _difficult, prop = 1) -> Array: #[withdrawpool, pepositpool]
	var withdraw_pool = []
	for i in range(_amount*prop):
		withdraw_pool.append(generate_random_wallet(_difficult))
	var deposit_pool = []
	for i in range(0, _amount*prop, prop):
#		var pool : Array = withdraw_pool[i] + withdraw_pool[i+1] + withdraw_pool[i+2]
		var pool = withdraw_pool[i]
		for j in range(1,prop+1):
			if j != 1 : pool += withdraw_pool[i + j - 1]
		pool.sort()
		pool.reverse()
		if randf() <= 0.25 and _difficult == 'extreme': pool.shuffle()
		deposit_pool.append(pool)
	return [withdraw_pool, deposit_pool]

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

func generate_random_wallet(difficult = 'random') -> Array:
	var difficulties = ['easy','normal','hard','extreme']
	if not difficulties.has(difficult):
		difficult = difficulties[randi_range(0,3)]
	var wallet = []
	if randf() <= 0.05: wallet.append(200)
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
		if randf() <= 0.5: wallet.append(200)
	return wallet
	
func wallet_sum(wallet : Array) -> int:
	var total := 0
	for _money in wallet:
		total += _money
	return total
