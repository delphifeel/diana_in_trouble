extends Sprite

# TODO: enemy.gd and friend.gd have duplicated code

export(String) var enemy_id
var _character = null
	
func character():
	return _character
	
func set_highlighted(value: bool):
	if value:
		self.self_modulate = Color(1.0, 1.0, 1.0, 1.7)
	else:
		self.self_modulate = Color(1.0, 1.0, 1.0)
		
func _prepare():
	var enemy_type = AllEnemies.get(enemy_id)
	_character = Character.new(
		enemy_id,
		$Actionbar,
		$Healthbar,
		enemy_type.stats
	)
	self.texture = enemy_type.sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare()
	
func _find_first_alive_friend_character():
	for f in GameState.friends():
		if not f.character().is_dead():
			return f.character()
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _character == null or _character.is_dead():
		return
		
	_character.process(delta)
	if _character.can_attack():
		_character.attack([_find_first_alive_friend_character()], _character.default_skill_name())
	
