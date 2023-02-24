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
		enemies = [
			"Drunk Man",
			"Drunk Man",
			"Drunk Man",
		],
		story_text = [
			"That was hard !!!"
		]
	},
}

func get(id: String):
	return _levels[id]
