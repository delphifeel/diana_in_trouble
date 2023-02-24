extends Reference

var _cooldown_left := 0.0
var _stats = null
var _health := 0.0
var _id := ""

var _ActionBar = null
var _HealthBar = null

# stats struct
	# might
	# insight
	# willpower
	# dexterity
	# defence
	# max_health
	# skill_names
func _init(id, ActionBar, HealthBar, stats):
	_id = id
	_ActionBar = ActionBar
	_HealthBar = HealthBar
	_health = stats.max_health
	_HealthBar.max_value = _health
	_HealthBar.value = _health
	_stats = stats
	
	_cooldown_left = 4.0
	_ActionBar.max_value = _cooldown_left
	_ActionBar.value = 0
	
func get_id():
	return _id
	
func get_stats():
	return _stats

func can_attack():
	return _cooldown_left <= 0.0

func attack(target, skill_name):
	assert(can_attack())
	var skill = AllSkills.get(skill_name)
	_go_to_cooldown(skill.cooldown * Settings.speed)
	
	# accuracy
	var highroll := 0
	var acc_value := 0
	for modifier in skill.accuracy:
		if modifier is int:
			acc_value += modifier
		else:
			var roll = Random.new() % _stats[modifier] + 1
			print("%s roll %s = %s" % [get_id(), modifier, roll])
			if roll > highroll:
				highroll = roll
			acc_value += roll
	if acc_value < 0:
		acc_value = 0
	
	var target_character = target.character()
	var target_defence = target_character.get_stats().defence
	print("%s attacks %s (%s vs %s)" % [get_id(), target_character.get_id(), acc_value, target_defence])
	if acc_value < target_defence:
		print("Miss")
		return
		
	# dmg
	var dmg_value := 0
	for modifier in skill.dmg:
		if modifier is int:
			dmg_value += modifier
		elif modifier == AllSkills.HighRoll:
			dmg_value += highroll
		else:
			var roll = Random.new() % _stats[modifier] + 1
			dmg_value += roll
			
	if dmg_value < 0:
		dmg_value = 0
	print("%s takes %s dmg" % [target_character.get_id(), dmg_value])
	target_character.take_dmg(dmg_value)
	
func take_dmg(amount):
	_health -= amount
	_HealthBar.value = _health
	
func is_dead():
	return _health <= 0.0

func process(delta):
	_process_actions(delta)

func _go_to_cooldown(time):
	_ActionBar.max_value = time
	_cooldown_left = time
	
func _process_actions(delta):
	_cooldown_left -= delta
	if _cooldown_left < 0.0:
		_cooldown_left = 0.0
		
	_ActionBar.value = _ActionBar.max_value - _cooldown_left