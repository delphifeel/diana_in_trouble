extends Node

onready var ActionLabel := get_node("/root/Game/ActionLabel")
onready var PlayerSkillsMenu := get_node("/root/Game/PlayerSkillsMenu")

enum SelectionState {
	None,
	Skill,
	Target,
	Friend,
}

var _selection_state = SelectionState.None
var _targets_enemies_indexes = []
var _selected_friend_index = 0
var _skill_to_use := ""

func on_skill_select(skill_name):
	_skill_to_use = skill_name
	_get_friend(_selected_friend_index).set_skill_to_use(skill_name)
	_change_selection_state(SelectionState.Target)
	
func switch_to_default_selection_state():
	_change_selection_state(SelectionState.Friend)
	
func _get_friend(index):
	return GameState.friends()[index]
	
func _get_enemy(index):
	return GameState.enemies()[index]
		
func _change_selection_state(value):
	_selection_state = value
	match _selection_state:
		SelectionState.Friend:
			_select_friend(0)
		SelectionState.Skill:
			var skill_button = PlayerSkillsMenu.get_child(0)
			skill_button.call_deferred("grab_focus")
		SelectionState.Target:
			if _is_skill_targets_all(_skill_to_use):	
				_set_all_targets()
			else:
				_set_default_target()
	
func _select_friend(index):
	var prev_friend = _get_friend(_selected_friend_index)
	prev_friend.set_highlighted(false)
	
	_selected_friend_index = index
	var friend = _get_friend(_selected_friend_index)
	friend.set_highlighted(true)
	PlayerSkillsMenu.prepare(friend.character().stats().skill_names)

func _set_all_targets():
	var indexes = []
	var i := 0
	for enemy in GameState.enemies():
		if not enemy.character().is_dead():
			indexes.append(i)
		i += 1

	_change_targets(indexes)
	
func _set_default_target():
	var i := 0
	for enemy in GameState.enemies():
		if not enemy.character().is_dead():
			_change_targets([i])
			break
		i += 1
			
func _is_skill_targets_all(skill_name):
	var skill = AllSkills.get(_skill_to_use)
	return "all" in skill and skill.all
			
func _change_targets(indexes):
	for i in _targets_enemies_indexes:
		_get_enemy(i).set_highlighted(false)
	
	_targets_enemies_indexes = indexes
	for i in _targets_enemies_indexes:
		_get_enemy(i).set_highlighted(true)
	_get_friend(_selected_friend_index).set_targets(_targets_enemies_indexes)
	
func _find_previous_target(index, all_targets):	
	var new_index = index
	var targets_iter = 0
	while targets_iter < all_targets.size():
		if new_index == 0:
			new_index = all_targets.size() - 1
		else:
			new_index -= 1
		if not all_targets[new_index].character().is_dead():
			return new_index
		targets_iter += 1
	
func _find_next_target(index, all_targets):	
	var new_index = index
	var targets_iter = 0
	while targets_iter < all_targets.size():
		if new_index == all_targets.size() - 1:
			new_index = 0
		else:
			new_index += 1
		if not all_targets[new_index].character().is_dead():
			return new_index
		targets_iter += 1
		
func _select_prev_target():
	match _selection_state:
		SelectionState.Friend:
			var new_index = _find_previous_target(_selected_friend_index, GameState.friends())
			_select_friend(new_index)
		SelectionState.Target:
			if _targets_enemies_indexes.size() > 1:
				return
			var new_index = _find_previous_target(_targets_enemies_indexes[0], GameState.enemies())
			_change_targets([new_index])
				
func _select_next_target():
	match _selection_state:
		SelectionState.Friend:
			var new_index = _find_next_target(_selected_friend_index, GameState.friends())
			_select_friend(new_index)
		SelectionState.Target:
			if _targets_enemies_indexes.size() > 1:
				return
			var new_index = _find_next_target(_targets_enemies_indexes[0], GameState.enemies())
			_change_targets([new_index])
			
	
func _next_selection_state():
	match _selection_state:
		SelectionState.Friend:
			_change_selection_state(SelectionState.Skill)
		#SelectionState.Skill:
		#	_change_selection_state(SelectionState.Target)
		SelectionState.Target:
			_change_selection_state(SelectionState.Friend)
		
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		_select_prev_target()
	elif Input.is_action_just_pressed("ui_up"):
		_select_next_target()
	elif Input.is_action_just_pressed("ui_select"):
		switch_to_default_selection_state()
	elif Input.is_action_just_pressed("ui_accept"):
		_next_selection_state()
				
	
