extends Player
class_name BigDude

@onready var camera_2d: Camera2D = $Camera2D
@onready var fsm: PlayerFSM = $PlayerFSM

func update_authority(id : int):
	set_multiplayer_authority(id, true)
	if camera_2d:
		camera_2d.enabled = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	fsm.physics_update(delta)

func _process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	fsm.update(delta)
	
