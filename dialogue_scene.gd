extends CanvasLayer
@export var label : Label
@export var button_holder : VFlowContainer
@export var button_scene : PackedScene
var text
signal next_line
signal line_finished
signal selected(option)
var wait = true
var isline_finished

func load_line(line):
	#Displays the line to the player
	wait = true
	if line:
		isline_finished = false
		var typing = ""
		for letter in line:
			typing += letter
			label.text = typing
			if wait:
				await get_tree().create_timer(0.025).timeout
		isline_finished = true
		emit_signal("line_finished")
		
func load_options(options):
	#Loads a new button for each option, connects the corresponding signals
	isline_finished = false
	var buttons = []
	for option in options:
		var instance = button_scene.instantiate() as Button
		button_holder.add_child(instance)
		instance.text = options[option]
		buttons.append(instance)
		instance.pressed.connect(select.bind(option, buttons))
	#Sets the neighbors for each button, this is an inbuilt godot feature for keyboard selection
	for button in buttons.size():
		buttons[button-1].focus_neighbor_bottom = buttons[button].get_path()
		buttons[button].focus_neighbor_top = buttons[button-1].get_path()
	buttons[0].grab_focus()
	await selected
	
#Called when a button is pressed
func select(option, buttons):
	#Deletes all the buttons and removes a skip_line at the right place based on arguments
	for x in buttons:
		x.queue_free()
	Dialogue.skip_lines.remove_at(Dialogue.skip_lines.find(option))
	emit_signal("next_line")

func _process(delta):
	#Waits for an input and either makes the whole line printed at once or goes to the next line if the line is finished
	if Input.is_action_just_pressed("next_line"):
		if isline_finished:
			emit_signal("next_line")
		else:
			wait = false
