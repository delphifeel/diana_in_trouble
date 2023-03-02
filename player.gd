extends Sprite

const HEALTH_MAX_VALUE := 100.0

var _character = null

onready var PlayerSkillsMenu = get_node("/root/Game/PlayerSkillsMenu")

func character():
	return _character

func _on_level_changed():
	var new_skills = GameState.level().new_skills
	if new_skills:
		character().stats().skill_names.append_array(new_skills)
	for skill in new_skills:
		PlayerSkillsMenu.add_skill(skill)

func _ready():
	var stats := {
		might = 6,
		insight = 10,
		willpower = 8,
		dexterity = 8,
		max_health = 30,
		skill_names = ["Paint Attack"],
		defense = 10,
	}
	_character = Character.new(
		"Diana",
		$Actionbar, 
		$Healthbar, 
		stats
	)
	GameState.connect("level_changed", self, "_on_level_changed")
	
func _get_active_skill():
	var skill = InputState.skill_to_use()
	if not skill:
		skill = _character.default_skill_name()
	return skill
	
func _process_active_skill():
	$ActiveSkillLabel.text = _get_active_skill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_character.process(delta)
	_process_active_skill()
	
	var targets_indexes = InputState.get_targets_indexes()
	if _character.can_attack() and targets_indexes.size() > 0:
		var targets = []
		for i in targets_indexes:
			var enemy = GameState.get_enemy_by_index(i)
			targets.append(enemy.character())
		_character.attack(targets, _get_active_skill())
