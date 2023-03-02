extends Node

var EnemyScene = load("res://Enemy.tscn")
onready var StoryText = get_node("/root/Game/StoryText")
onready var PlayerSkillsMenu = get_node("/root/Game/PlayerSkillsMenu")

signal level_changed

const _SPAWN_POINTS := [
	Vector2(335.0, 101.0),
	Vector2(382.0, 38.0),
	Vector2(382.0, 151.0),
]

var _active_level_number := 1
var _all_enemies = []
var _is_story_phase := true

func enemies():
	return _all_enemies

func switch_to_game_phase():
	_is_story_phase = false
	get_tree().paused = false
	StoryText.visible = false
	PlayerSkillsMenu.visible = true
	InputState.change_selection_state(InputState.SelectionState.Skill)

func level_number():
	return _active_level_number

func level():
	return Levels.get("level" + String(_active_level_number))
	
func _next_level():
	_active_level_number += 1
	_spawn_enemies()
	_switch_to_story_phase()
	emit_signal("level_changed")

func _switch_to_story_phase():
	_is_story_phase = true
	get_tree().paused = true
	PlayerSkillsMenu.visible = false
	StoryText.init()
	StoryText.visible = true	

func _spawn_enemies():	
	var level = level()
	var level_enemies_count = level.enemies.size()
	_spawn_enemy(level.enemies[0])
	if level_enemies_count > 1:
		_spawn_enemy(level.enemies[1])
	if level_enemies_count > 2:
		_spawn_enemy(level.enemies[2])
	
func _spawn_enemy(enemy_id):
	var enemy = EnemyScene.instance()
	var index = _all_enemies.size()
	enemy.enemy_id = enemy_id
	enemy.enemy_index = index
	add_child(enemy)
	enemy.position = _SPAWN_POINTS[index]
	_all_enemies.push_back(enemy)
	
func _destroy_enemies():
	for enemy in _all_enemies:
		enemy.queue_free()
	_all_enemies.clear()
	
func _process(_delta):
	var all_dead := true
	for enemy in _all_enemies:
		if not enemy.character().is_dead():
			all_dead = false
			break
			
	if all_dead:
		_destroy_enemies()
		_next_level()

func _ready():
	_spawn_enemies()
	_switch_to_story_phase()
	
