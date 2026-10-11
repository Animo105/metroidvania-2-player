extends Control


@onready var peer_label: Label = $PanelContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/PeerLabel
@onready var host_button_set: HBoxContainer = $PanelContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/HostButtonSet


@onready var panel: PanelContainer = $PanelContainer/CenterContainer/Panel

@onready var button_start_game: Button = $PanelContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/HostButtonSet/ButtonStartGame
@onready var label_player_1: Label = $PanelContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/LabelPlayer1
@onready var label_player_2: Label = $PanelContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/LabelPlayer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.offset_transform_position = Vector2(0, 500)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	host_button_set.visible = Network.is_owner
	peer_label.visible = not Network.is_owner
	update_lobby()
	var tween : Tween = create_tween()
	tween.tween_property(panel, "offset_transform_position:y", 0, 0.3)


func update_lobby():
	print("update lobby")
	label_player_1.text = "LOADING"
	label_player_2.text = "LOADING"
	var number_member : int = Steam.getNumLobbyMembers(Network.lobby_id)
	for i in range(number_member):
		var steam_id : int = Steam.getLobbyMemberByIndex(Network.lobby_id, i)
		var steam_name : String = Steam.getFriendPersonaName(steam_id)
		if steam_id == Network.owner_id:
			label_player_1.text = "%s (%s)" % [steam_name, TranslationServer.translate("HOST")]
		else:
			label_player_2.text = steam_name
	button_start_game.disabled = number_member != 2

func _on_lobby_chat_update(_lobby_id : int, _changed_id : int, _making_change_id : int, _chat_state : int):
	update_lobby()

func _on_quit_pressed() -> void:
	Network.leave_lobby()

func _on_button_start_game_pressed() -> void:
	if not Network.is_owner : return
	if  Steam.getNumLobbyMembers(Network.lobby_id) != 2: return
	Globals.set_up_game()

func _on_button_kick_player_pressed() -> void:
	if not Network.is_owner : return
	var peers = multiplayer.get_peers()
	if peers.size() == 1:
		Network.kick_from_lobby.rpc_id(peers[0])


func _on_button_pressed() -> void:
	update_lobby()
