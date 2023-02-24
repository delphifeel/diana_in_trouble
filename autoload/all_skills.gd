extends Node

const Might := "might"
const Insight := "insight"
const Willpower := "willpower"
const Dexterity := "dexterity"
const HighRoll := "highRoll"

const _skills = {
	# Diana skills
	"Paint Attack": {
		accuracy = [Insight, Dexterity, 1],
		dmg = [HighRoll, 5],
		cooldown = 4.0,
	},
	"Love Attack": {
		accuracy = [Insight, Willpower, 4],
		dmg = [HighRoll, 20],
		cooldown = 8.0,
	},
	
	# Enemy skills
	"Drunk Attack": {
		accuracy = [Might, Might, -4],
		dmg = [HighRoll],
		cooldown = 4.0,
	},
}

func get(name: String):
	return _skills[name]
