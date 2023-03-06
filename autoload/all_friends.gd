extends Node

const _friends = {
	"Diana": {
		sprite = preload("res://assets/player.png"),
		stats = {
			might = 6,
			insight = 10,
			willpower = 8,
			dexterity = 8,
			max_health = 50,
			skill_names = ["Paint Attack"],
			defense = 10,
		},
	},
	"Liza": {
		sprite = preload("res://assets/player.png"),
		stats = {
			might = 8,
			insight = 8,
			willpower = 6,
			dexterity = 10,
			max_health = 60,
			skill_names = ["Pistol Hit"],
			defense = 12,
		},
	},
}

func get(id: String):
	return _friends[id]
