extends Node

onready var ActionLabel := get_node("/root/Game/ActionLabel")
onready var Player := get_node("/root/Game/Player")
onready var PlayerSkillsMenu := get_node("/root/Game/PlayerSkillsMenu")

signal target_enemy_changed(enemies_indexes)

enum SelectionState {
	None,
	Skill,
	Target,
}

var _selection_state = SelectionState.None
var _targets_indexes = []
var _skill_button = null
var _skill_to_use := ""
	
func get_targets_indexes():
	return _targets_indexes
	
func set_skill_to_use(skill_to_use, skill_button):
	_skill_button = skill_button
	_skill_to_use = skill_to_use
	
func skill_to_use():
	return _skill_to_use
		
func change_selection_state(value):
	_selection_state = value
	match _selection_state:
		SelectionState.Skill:
			_set_default_target()
			#ActionLabel.text = "Select Skill To Use"
			_skill_to_use = ""
			_skill_button = PlayerSkillsMenu.get_child(0)
			_skill_button.call_deferred("grab_focus")
		SelectionState.Target:
			if _is_skill_targets_all(_skill_to_use):	
				_set_all_targets()
			else:
				_set_default_target()
			_skill_button.call_deferred("release_focus")
			#ActionLabel.text = "Select target"
	
func _set_all_targets():
	var indexes = []
	var i := 0
	for enemy in GameState.enemies():
		if not enemy.character().is_dead():
			indexes.append(i)
		i += 1

	_change_targets(indexes)
	
func _set_default_target():
	var target_found := false
	var i := 0
	for enemy in GameState.enemies():
		if not enemy.character().is_dead():
			target_found = true
			break
		i += 1
	if target_found:
		_change_targets([i])
	
			
func _is_skill_targets_all(skill_name):
	var skill = AllSkills.get(_skill_to_use)
	return "all" in skill and skill.all
			
func _change_targets(indexes):	
	_targets_indexes = indexes
	emit_signal("target_enemy_changed", _targets_indexes)
	
func _select_prev_target_enemy():
	if _targets_indexes.size() != 1:
		return
	
	var new_index = _targets_indexes[0]
	var enemies = GameState.enemies()
	var enemies_i = 0
	
	while enemies_i < enemies.size():
		if new_index == 0:
			new_index = enemies.size() - 1
		else:
			new_index -= 1
		if not enemies[new_index].character().is_dead():
			break
		enemies_i += 1
		
	_change_targets([new_index])
	
func _select_next_target_enemy():
	if _targets_indexes.size() != 1:
		return
	
	var new_index = _targets_indexes[0]
	var enemies = GameState.enemies()
	var enemies_i = 0
	
	while enemies_i < enemies.size():
		if new_index == enemies.size() - 1:
			new_index = 0
		else:
			new_index += 1
		if not enemies[new_index].character().is_dead():
			break
		enemies_i += 1
		
	_change_targets([new_index])
		
func _process(delta):
	if _selection_state == SelectionState.Target:
		if Input.is_action_just_pressed("ui_down"):
			_select_prev_target_enemy()
		elif Input.is_action_just_pressed("ui_up"):
			_select_next_target_enemy()
				
	
