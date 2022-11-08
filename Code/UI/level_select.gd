extends PanelContainer



func _ready() -> void:
	for level in %LevelGrid.get_children():
		var level_number = 'level_button_'  + ("%02d" % (level.get_index() + 1))
		if has_method(level_number):
			level.connect('button_up', Callable(self, level_number))


func go_to_level(_pool, _gaveta = [], interval = 10.0):
	Game.change_to_level(_pool, _gaveta, interval)



func level_button_01():
	var level_pool = []
	var basic_client = {}
	basic_client.category = 'deposit'
	for i in range(6):
		basic_client.value = generate_random_wallet('easy')
		level_pool.append(basic_client.duplicate())
	Game.show_confirm('01',"res://UI/Tips/level_01.tscn")
	go_to_level(level_pool)

func level_button_02():
	var level_pool = []
	var basic_client = {}
	basic_client.category = 'deposit'
	for i in range(8):
		basic_client.value = generate_random_wallet('normal')
		level_pool.append(basic_client.duplicate())
	Game.show_confirm('02')
	go_to_level(level_pool)
	
func level_button_03():
	var level_gaveta = [1,1,1,1,1]
	var level_pool = []
	var basic_client = {}
	basic_client.category = 'deposit'
	for i in range(12):
		basic_client.value = generate_random_wallet('normal')
		level_pool.append(basic_client.duplicate())
	Game.show_confirm('03')
	go_to_level(level_pool, level_gaveta)

func level_button_04():
	var level_pool = []
	var basic_client = {}
	basic_client.category = 'deposit'
	for i in range(8):
		basic_client.value = generate_random_wallet('normal')
		level_pool.append(basic_client.duplicate())
	for i in range(8):
		basic_client.value = generate_random_wallet('hard')
		level_pool.append(basic_client.duplicate())
	level_pool.shuffle()
	Game.show_confirm('04')
	go_to_level(level_pool)


func level_button_18():
	var level_gaveta = [1,2]
	var level_pool = generate_bank_client_pool(6, 'normal', 3)
	level_pool += generate_bank_client_pool(2, 'hard')
	level_pool.shuffle()
	var boss_client = {}
	boss_client.category = 'deposit'
	boss_client.value = [200,200,200,200,200]
	level_pool.append(boss_client)
	go_to_level(level_pool, level_gaveta)
	


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
