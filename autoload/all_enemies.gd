extends Node

const _enemies = {
	"Drunk Man": {
		sprite = preload("res://assets/enemy.png"),
		stats = {
			might = 10,
			insight = 4,
			willpower = 4,
			dexterity = 6,
			skill_names = ["Drunk Attack"],
			max_health = 50,
			defense = 6,
		},
	},
}

func get(id: String):
	return _enemies[id]
