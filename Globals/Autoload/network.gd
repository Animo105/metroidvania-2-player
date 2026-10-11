extends Node

signal lobby_update

var peer : MultiplayerPeer

var lobby_id : int = 0
var via_steam:
	get(): return lobby_id != 0

func _ready() -> void:
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_join_request)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _process(_delta: float) -> void :
	Steam.run_callbacks()

func _lobby_entered():
	SceneManager.load_from_file("res://UI/Lobby Overview/lobby_overview.tscn")

func host_lobby():
	Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY, 2) #2 = max members

func _on_lobby_created(connect_result : int, steam_lobby_id : int):
	if connect_result != Steam.RESULT_OK: return
	lobby_id = steam_lobby_id
	peer = SteamMultiplayerPeer.new()
	peer.server_relay = true
	peer.create_host()
	multiplayer.multiplayer_peer = peer
	_lobby_entered()

func _on_lobby_joined(steam_lobby_id : int, _permissions : int, _locked : bool, response : int):
	if response != Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS: return
	lobby_id = steam_lobby_id
	if not multiplayer.peer:
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		peer.create_client(Steam.getLobbyOwner(steam_lobby_id))
		multiplayer.multiplayer_peer = peer
	_lobby_entered()

func leave_lobby():
	if via_steam:
		Steam.leaveLobby(lobby_id)
	multiplayer.multiplayer_peer = null
	peer = null
	SceneManager.load_from_file("res://UI/Menu/menu.tscn")

@rpc("authority")
func kick_from_lobby():
	leave_lobby()

func _on_join_request(steam_lobby_id : int, _steam_id : int):
	Steam.joinLobby(steam_lobby_id)

const LOCAL_PORT := 7777

func host_local() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(LOCAL_PORT, 1) # 1 = max clients
	multiplayer.multiplayer_peer = peer
	print("Serveur local créé sur le port ", LOCAL_PORT)
	_lobby_entered()

func join_local() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", LOCAL_PORT)
	multiplayer.multiplayer_peer = peer
	print("Connexion au serveur local en cours...")
	_lobby_entered()

func _on_peer_connected(id: int) -> void:
	print("Un joueur a rejoint : ", id)
	lobby_update.emit()
func _on_peer_disconnected(id: int) -> void:
	print("Un joueur a quitté : ", id)
	lobby_update.emit()
func _on_connected_to_server() -> void:
	print("Connecté au host !")
	lobby_update.emit()
func _on_connection_failed() -> void:
	print("Échec de connexion au host.")
func _on_server_disconnected() -> void:
	print("Déconnecté du host.")
	lobby_update.emit()
