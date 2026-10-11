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
	Network.lobby_update.connect(update_lobby)
	host_button_set.visible = multiplayer.is_server()
	peer_label.visible = not multiplayer.is_server()
	update_lobby()
	var tween : Tween = create_tween()
	tween.tween_property(panel, "offset_transform_position:y", 0, 0.3)

func _set_names_with_steam():
	for i in range(Steam.getNumLobbyMembers(Network.lobby_id)):
		var steam_id : int = Steam.getLobbyMemberByIndex(Network.lobby_id, i)
		var steam_name : String = Steam.getFriendPersonaName(steam_id)
		if steam_id == Steam.getSteamID():
			label_player_1.text = "%s (%s)" % [steam_name, TranslationServer.translate("HOST")]
		else:
			label_player_2.text = steam_name

func _set_name_with_peer():
	label_player_1.text = str(multiplayer.get_unique_id())
	if multiplayer.get_peers().size() == 1:
		label_player_2.text = str(multiplayer.get_peers()[0])

func update_lobby():
	label_player_1.text = "LOADING"
	label_player_2.text = "LOADING"
	if Network.via_steam:
		_set_names_with_steam()
	else:
		_set_name_with_peer()
	button_start_game.disabled = multiplayer.get_peers().size() != 1

func _on_quit_pressed() -> void:
	Network.leave_lobby()

func _on_button_start_game_pressed() -> void:
	if not multiplayer.is_server(): return
	if  multiplayer.get_peers().size() != 1: return
	Globals.set_up_game()

func _on_button_kick_player_pressed() -> void:
	if not multiplayer.is_server(): return
	var peers = multiplayer.get_peers()
	if peers.size() == 1:
		Network.kick_from_lobby.rpc_id(peers[0])
