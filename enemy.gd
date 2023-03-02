extends Sprite

export(String) var enemy_id
export(int) var enemy_index

var _enemy_type = null
var _prev_selecting_target := false
var _character = null

onready var Player := get_node("/root/Game/Player")
	
func character():
	return _character
	
func _focus():
	self.self_modulate = Color(1.0, 1.0, 1.0, 1.7)
		
func _unfocus():
	self.self_modulate = Color(1.0, 1.0, 1.0)
		
func _prepare():
	_enemy_type = AllEnemies.get(enemy_id)
	_character = null
	_character = Character.new(
		enemy_id,
		$Actionbar,
		$Healthbar,
		_enemy_type.stats
	)
	self.texture = _enemy_type.sprite

func _on_enemy_change(indexes):
	if indexes.has(enemy_index):
		_focus()
	else:
		_unfocus()

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare()
	InputState.connect("target_enemy_changed", self, "_on_enemy_change")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _character == null or _character.is_dead():
		return
		
	_character.process(delta)
	if _character.can_attack():
		_character.attack([Player.character()], _enemy_type.stats.skill_names[0])
	
