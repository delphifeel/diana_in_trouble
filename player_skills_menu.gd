extends GridContainer

export(NodePath) var _player_node_path
onready var Player := get_node(_player_node_path)
export(NodePath) var _action_label_path
onready var ActionLabel := get_node(_action_label_path)
onready var Enemy := get_node("/root/Game/Enemy1")


# Called when the node enters the scene tree for the first time.
func _ready():
	for skill_name in Player.character().get_stats().skill_names:
		var skill_button := Button.new()
		skill_button.text = skill_name
		# warning-ignore:return_value_discarded
		skill_button.connect("pressed", self, "_on_skill_pressed", [skill_name])
		add_child(skill_button)

func _on_skill_pressed(skill_name):
	InputState.set_selecting_target(true)
	InputState.set_skill_to_use(skill_name)
	
