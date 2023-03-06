extends Node

const _levels = {
	level1 = {
		enemies = [
			"Drunk Man",
		],
		story_text = [
			"Oh my, oh my, i really getting late to dance practice.\nI need to hurry up.",
			"Also, wait, who is this drunk ? He is kinda suspicious.",
		],
	},
	level2 = {
		new_skills = {
			"Diana": ["Love Attack"],
		},
		enemies = [
			"Drunk Man",
			"Drunk Man",
			"Drunk Man",
		],
		story_text = [
			"That was hard !!!"
		]
	},
	level3 = {
		new_friends = [
			"Liza",
		],
		enemies = [
			"Drunk Man",
			"Drunk Man",
			"Drunk Man",
		],
		story_text = [
			"Oh hi Liza. Wanna help me with those bastards ?",
		],
	},
}

func get(id: String):
	return _levels[id]
