extends Spatial

export(String, FILE) var import_vrm_path = "res://addons/vrm/import_vrm.gd"
export(String, FILE) var motion_path = "res://miku_vrm_motion/art/demo_vmd/anim_pronama/melt.vmd"
export(String, FILE) var model_path = "res://miku_vrm_motion/art/demo_vrms/4490707391186690073.vrm"

func _ready():
	var vmd_player: VMDPlayerBake
	var animator: VRMAnimatorBake
	var VRMImport = load(import_vrm_path)
	var model_instance: Spatial
	if model_path.begins_with("res://"):
		var new_model_instance = load(model_path)
		if new_model_instance != null:
			model_instance = new_model_instance.instance()
	if model_instance == null:
		var vrm_loader = load("res://addons/vrm/vrm_loader.gd").new()
		model_instance = vrm_loader.import_scene(model_path, 1, 1000, false)
	model_instance.rotate_y(deg2rad(180))
	animator = VRMAnimatorBake.new()
	vmd_player = VMDPlayerBake.new()
	animator.add_child(model_instance)
	add_child(animator)
	vmd_player.animator_path = animator.get_path()
	add_child(vmd_player)
	var paths : Array
	paths.push_back(motion_path)
	vmd_player.load_motions(paths)
	for path in paths:
		var anims : Dictionary = vmd_player.save_motion(path.get_file().get_basename())
		var new_animation_player : AnimationPlayer= model_instance.get_node("anim")
		for key_i in anims.keys():
			new_animation_player.add_animation(key_i, anims[key_i])
		var scene : PackedScene = PackedScene.new()
		scene.pack(model_instance)
		ResourceSaver.save("res://%s_%s.scn" % [model_path.get_file().get_basename(), path.get_file().get_basename()], 
			scene, ResourceSaver.FLAG_COMPRESS)


func _process(_delta):
	get_tree().quit(0)
