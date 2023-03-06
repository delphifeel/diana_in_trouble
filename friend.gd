extends Sprite

export(String) var friend_id

var _character = null
var _skill_to_use := ""
var _targets_indexes = []

func set_skill_to_use(skill_name):
	_skill_to_use = skill_name
	
func set_targets(targets_indexes):
	_targets_indexes = targets_indexes

func character():
	return _character

func _on_level_changed():
	if  (
			"new_skills" in GameState.level() and
			GameState.level().new_skills.has(friend_id)
		):
		var friend_new_skills = GameState.level().new_skills[friend_id]
		character().stats().skill_names.append_array(friend_new_skills)
		
	
func set_highlighted(value: bool):
	if value:
		self.self_modulate = Color(1.0, 1.0, 1.0, 1.7)
	else:
		self.self_modulate = Color(1.0, 1.0, 1.0)
		
func _prepare():
	var friend_type = AllFriends.get(friend_id)
	_character = Character.new(
		friend_id,
		$Actionbar,
		$Healthbar,
		friend_type.stats
	)
	self.texture = friend_type.sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare()
	GameState.connect("level_changed", self, "_on_level_changed")

func _get_active_skill():
	if _skill_to_use:
		return _skill_to_use
	return _character.default_skill_name()
	
func _process_active_skill():
	$ActiveSkillLabel.text = _get_active_skill()

func _find_first_alive_enemy_character():
	for enemy in GameState.enemies():
		if not enemy.character().is_dead():
			return enemy.character()
	return null
	
func _filter_alive_enemies_characters(indexes):
	var result = []
	for i in indexes:
		var enemy = GameState.enemies()[i]
		if not enemy.character().is_dead():
			result.append(enemy.character())
	return result

func _process(delta):
	if _character == null or _character.is_dead():
		return
	
	_character.process(delta)
	_process_active_skill()
	
	if _character.can_attack():
		var characters_to_attack = []
		if _targets_indexes.size() > 0:
			characters_to_attack = _filter_alive_enemies_characters(_targets_indexes)

		if characters_to_attack.size() == 0:
			characters_to_attack.append(_find_first_alive_enemy_character())
				
		_character.attack(characters_to_attack, _get_active_skill())
