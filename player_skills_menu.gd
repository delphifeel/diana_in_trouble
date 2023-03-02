extends GridContainer

onready var Player = get_node("/root/Game/Player")

func add_skill(skill_name):
	var skill_button := Button.new()
	skill_button.text = skill_name
	# warning-ignore:return_value_discarded
	skill_button.connect("pressed", self, "_on_skill_pressed", [skill_button, skill_name])
	add_child(skill_button)

func _ready():	
	for skill_name in Player.character().stats().skill_names:
		add_skill(skill_name)

func _on_skill_pressed(button, skill_name):
	InputState.set_skill_to_use(skill_name, button)
	InputState.change_selection_state(InputState.SelectionState.Target)
