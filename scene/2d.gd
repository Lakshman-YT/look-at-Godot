extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length() > 0:
		$Button.button_pressed = true
		$Button2.button_pressed = not $Button.button_pressed
	else:
		$Button.button_pressed = false
		$Button2.button_pressed = not $Button.button_pressed
