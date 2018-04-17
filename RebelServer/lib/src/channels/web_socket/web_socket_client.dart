part of rebel_server;

/// Channel client for websocket
class WebsocketClient extends ServerChannelClient {
  /// Web socket
  dynamic socket;

  /// Constructor
  WebsocketClient(int clientId, this.socket, ServerChannel channel) : super(clientId, channel);
}