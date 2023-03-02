extends Label

var _index := 0
var _prev_level_number := 0
var _level = null

func init():
	_index = 0
	_prev_level_number = 0
	_level = null

func _process(delta):
	var level_number = GameState.level_number()
	if level_number != _prev_level_number:
		_prev_level_number = level_number
		_level = GameState.level()
		self.text = _level.story_text[_index]
		
	if Input.is_action_just_pressed("ui_select"):
		if _index + 1 == _level.story_text.size():
			GameState.switch_to_game_phase()
			return
			
		_index += 1
		self.text = _level.story_text[_index]
