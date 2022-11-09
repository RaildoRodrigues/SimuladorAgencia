extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bt_start_button_up() -> void:
	%SFX.play()
	var main_level = "res://UI/Pages/level_menu.tscn"
	Game.change_to_menu(main_level)


func _on_bt_exit_button_up() -> void:
	%SFX.play()
	get_tree().quit()


func level_button_survival():
	var easy_pool = generate_bank_client_pool(12, 'easy', 2)
	easy_pool.shuffle()
	var medium_pool = generate_bank_client_pool(6, 'normal', 3)
	medium_pool.shuffle()
	var hard_pool = generate_bank_client_pool(6, 'hard', 3)
	hard_pool.shuffle()
	var extreme_pool = generate_bank_client_pool(14, 'random', 2)
	extreme_pool.shuffle()
	var level_pool = extreme_pool + hard_pool + medium_pool + easy_pool
	Game.level_name = 'survival'
	Game.level_tip = "res://UI/Tips/level_survival.tscn"
	Game.show_confirm()
	Game.change_to_level(level_pool, [], 10.0)



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
#	if randf() <= 0.05: wallet.append(200)
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
		if randf() <= 0.05: wallet.append(200)
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
	


func _on_bt_survival_button_up() -> void:
	level_button_survival()
