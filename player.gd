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
	skill_names = ["Paint Attack", "Love Attack"],
	defence = 10,
}

func character():
	return _character

# Called when the node enters the scene tree for the first time.
func _ready():
	_character = Character.new(
		"Diana",
		$Actionbar, 
		$Healthbar, 
		_stats
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_character.process(delta)
