extends Entity
class_name Player

var fsm : PlayerFSM
var input_component : PlayerInputComponent

var owner_peer_id: int
var is_local_player := false

func _ready() -> void:
	for child in get_children():
		if child is PlayerFSM:
			fsm = child
		elif child is PlayerInputComponent:
			input_component = child
			input_component.player = self
	is_local_player = (multiplayer.get_unique_id() == owner_peer_id)
	set_multiplayer_authority(owner_peer_id, true)

func _physics_process(delta: float) -> void:
	if is_local_player:
		fsm.physics_update(delta)

func _process(delta: float) -> void:
	if is_local_player:
		fsm.update(delta)

func setup_player(peer_id: int) -> void:
	owner_peer_id = peer_id

func apply_horizontal_movement( direction: float, _delta: float, in_air: bool) -> void:
	var target_speed: float = 0
	if in_air:
		target_speed = direction * air_speed * speed_multiplier * airborn_multiplier
	else:
		target_speed = direction * move_speed * speed_multiplier

	if direction == 0.0:
		velocity.x = 0
	else:
		last_direction = direction
		velocity.x = target_speed
