extends GridContainer

func prepare(skill_names):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
	for skill in skill_names:
		_add_skill(skill)

func _add_skill(skill_name):
	var skill_button := Button.new()
	skill_button.text = skill_name
	# warning-ignore:return_value_discarded
	skill_button.connect("pressed", self, "_on_skill_pressed", [skill_button, skill_name])
	self.add_child(skill_button)

func _on_skill_pressed(button, skill_name):
	button.call_deferred("release_focus")
	InputState.on_skill_select(skill_name)
