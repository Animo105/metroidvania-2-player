extends Node

signal host_created

const LOBBY_TYPE : Steam.LobbyType = Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY
const MAX_MEMBERS : int = 2

var peer : SteamMultiplayerPeer

var owner_id : int = 0
var is_owner : bool :
	get(): return owner_id == personal_id
var personal_id : int = 0
var lobby_id : int

func _ready() -> void:
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)

func _process(_delta: float) -> void :
	Steam.run_callbacks()

func host_lobby():
	Steam.createLobby(LOBBY_TYPE, MAX_MEMBERS)

func _on_lobby_created(connect_result : int, steam_lobby_id : int):
	if connect_result != Steam.RESULT_OK: return
	lobby_id = steam_lobby_id
	peer = SteamMultiplayerPeer.new()
	peer.server_relay = true
	peer.create_host()
	multiplayer.multiplayer_peer = peer
	host_created.emit()

func _on_lobby_joined(steam_lobby_id : int, _permissions : int, _locked : bool, response : int):
	if response != Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS: return
	lobby_id = steam_lobby_id
	owner_id = Steam.getLobbyOwner(steam_lobby_id)
	personal_id = Steam.getSteamID()
	if owner_id != personal_id :
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client(Steam.getLobbyOwner(steam_lobby_id))
		multiplayer.multiplayer_peer = peer
	SceneManager.load_from_file("res://UI/LobbyOverview/lobby_overview.tscn")

func leave_lobby():
	Steam.leaveLobby(lobby_id)
	multiplayer.multiplayer_peer = null
	peer = null
	SceneManager.load_from_file("res://UI/Menu/menu.tscn")

@rpc("authority")
func kick_from_lobby():
	leave_lobby()

func _on_join_request(steam_lobby_id : int, _steam_id : int):
	Steam.joinLobby(steam_lobby_id)
