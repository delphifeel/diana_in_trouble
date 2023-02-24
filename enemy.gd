extends Sprite

var enemy_id

var _enemy_type = null
var _prev_selecting_target := false
var Character = load("res://character.gd")
var _character = null

onready var Player := get_node("/root/Game/Player")
	
func character():
	return _character
	
func _on_mouse_entered():
	if InputState.is_selecting_target():
		self.self_modulate = Color(1.0, 1.0, 1.0, 1.7)
		InputState.set_target(self)
		
func _on_mouse_exited():
	if InputState.is_selecting_target():
		self.self_modulate = Color(1.0, 1.0, 1.0)
		InputState.set_target(null)
		
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

# Called when the node enters the scene tree for the first time.
func _ready():
	_prepare()
	$Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_on_mouse_exited")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _character == null or _character.is_dead():
		return
		
	var selecting_target = InputState.is_selecting_target()
	if selecting_target != _prev_selecting_target:
		if not selecting_target:
			self.self_modulate = Color(1.0, 1.0, 1.0)
		_prev_selecting_target = selecting_target
		
	_character.process(delta)
		
	if _character.can_attack():
		_character.attack(Player, _enemy_type.stats.skill_names[0])
