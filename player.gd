extends Sprite

const HEALTH_MAX_VALUE := 100.0

var _character = null
var Character = load("res://character.gd")
var _stats := {
	might = 6,
	insight = 10,
	willpower = 8,
	dexterity = 8,
	max_health = 30,
	skill_names = ["Paint Attack"],
	defense = 10,
}

onready var PlayerSkillsMenu = get_node("/root/Game/PlayerSkillsMenu")

func character():
	return _character


func _on_level_changed():
	var new_skills = GameState.get_level().new_skills
	if new_skills:
		character().get_stats().skill_names.append_array(new_skills)
	for skill in new_skills:
		PlayerSkillsMenu.add_skill(skill)

func _ready():
	_character = Character.new(
		"Diana",
		$Actionbar, 
		$Healthbar, 
		_stats
	)
	GameState.connect("level_changed", self, "_on_level_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_character.process(delta)
