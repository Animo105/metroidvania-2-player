extends Control

@onready var host_button_set: HBoxContainer = $PanelContainer/CenterContainer/MemberList/MarginContainer/VBoxContainer/HostButtonSet
@onready var peer_label: Label = $PanelContainer/CenterContainer/MemberList/MarginContainer/VBoxContainer/PeerLabel


@onready var label_player_1: Label = $PanelContainer/CenterContainer/MemberList/MarginContainer/VBoxContainer/LabelPlayer1
@onready var label_player_2: Label = $PanelContainer/CenterContainer/MemberList/MarginContainer/VBoxContainer/LabelPlayer2
@onready var button_start_game: Button = $PanelContainer/CenterContainer/MemberList/MarginContainer/VBoxContainer/HostButtonSet/ButtonStartGame


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.lobby_chat_update.connect(update_lobby)
	host_button_set.visible = Network.is_owner
	peer_label.visible = not Network.is_owner

func update_lobby(lobby_id : int, _changed_id : int, _making_change_id : int, _chat_state : int):
	label_player_1.text = "LOADING"
	label_player_2.text = "LOADING"
	var number_member : int = Steam.getNumLobbyMembers(lobby_id)
	for i in range(number_member):
		var steam_id : int = Steam.getLobbyMemberByIndex(lobby_id, i)
		var steam_name : String = Steam.getFriendPersonaName(steam_id)
		if steam_id == Network.owner_id:
			label_player_1.text = "%s (%s)" % [steam_name, TranslationServer.translate("HOST")]
		else:
			label_player_2.text = steam_name
	button_start_game.disabled = number_member == 2


func _on_quitt_pressed() -> void:
	Network.leave_lobby()


func _on_button_start_game_pressed() -> void:
	if not Network.is_owner : return
	print("Launching game!")


func _on_button_kick_player_pressed() -> void:
	if not Network.is_owner : return
	var peers = multiplayer.get_peers()
	if peers.size() == 1:
		Network.kick_from_lobby.rpc_id(peers[0])
