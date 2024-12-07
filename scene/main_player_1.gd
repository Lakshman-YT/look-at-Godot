extends CharacterBody3D
const SPEED = 3.0
var movement = -1.0
var tween = false

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length() > 0:
		movement = lerp(movement , 0.0 , 3 * delta)
		if tween:
			tween.kill()
			tween = 0
		$AnimationTree.set("parameters/BlendSpace1D/blend_position" , movement)
	else:
		if not tween:
			tween = create_tween().bind_node(self)
			var t = movement + 1
			tween.tween_property(self, "movement" , -1, t).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)	
		$AnimationTree.set("parameters/BlendSpace1D/blend_position" , movement)
	velocity = SPEED * $AnimationTree.get_root_motion_position() / delta
	move_and_slide()

@onready var neck = $neck
@onready var look_object = $"../camera/lookobject"
@onready var skeleton = $player/Armature_005/Skeleton3D
var new_rotation
var max_horizontal_angle = 90
var max_vertical_angle = 20
var bonesmoothrot = 0.0

func look_at_object(delta):
	var neck_bone = skeleton.find_bone("mixamorig_Neck")
	neck.look_at(look_object.global_position, Vector3.UP ,true)
	var neck_rotation = skeleton.get_bone_pose_rotation(neck_bone)
	var marker_rotation_degrees = neck.rotation_degrees
	marker_rotation_degrees.x = clamp(marker_rotation_degrees.x, -max_vertical_angle, max_vertical_angle)
	marker_rotation_degrees.y = clamp(marker_rotation_degrees.y, -max_horizontal_angle, max_horizontal_angle)
	bonesmoothrot = lerp_angle(bonesmoothrot, deg_to_rad(marker_rotation_degrees.y), 2 * delta)
	new_rotation = Quaternion.from_euler(Vector3(deg_to_rad(marker_rotation_degrees.x), bonesmoothrot, 0))
	skeleton.set_bone_pose_rotation(neck_bone, new_rotation)

func _process(delta: float) -> void:
	look_at_object(delta)
	
