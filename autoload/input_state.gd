extends Node

var _selecting_target := false
var _target = null
var _skill_to_use := ""

onready var ActionLabel := get_node("/root/Game/ActionLabel")
onready var Player := get_node("/root/Game/Player")

func is_selecting_target() -> bool:
	return _selecting_target

func set_selecting_target(value: bool):
	_selecting_target = value
	if _selecting_target:
		ActionLabel.text = "Select target"
	else:
		ActionLabel.text = ""
		
func set_target(target):
	_target = target
	
func set_skill_to_use(skill_to_use: String):
	_skill_to_use = skill_to_use
	Player.get_node("ActiveSkillLabel").text = _skill_to_use
		
func _input(event):
	if event is InputEventMouseButton:
		if (event.button_index == BUTTON_LEFT and 
			event.pressed and
			_selecting_target):
			
			var player_character = Player.character()
			if _skill_to_use and _target and player_character.can_attack():
				player_character.attack(_target, _skill_to_use)
				set_selecting_target(false)
				set_skill_to_use("")
