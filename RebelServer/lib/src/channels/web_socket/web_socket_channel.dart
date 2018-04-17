part of rebel_server;

/// Websocket channel
class WebsocketChannel extends ServerChannel {
  /// Constructor
  WebsocketChannel(int port, ServerChannelObserver observer)
      : super(port, observer);

  /// Send data to client
  @override
  Future send(ChannelClient client, List<int> data) async {
    if (client is WebsocketClient) {
      client.socket.sink.add(data);
    }
  }

  /// Start listen
  @override
  Future start() async {
    var handler = webSocketHandler((webSocket) {
      var id = uuidGenerator.v4().hashCode;
      final client = new WebsocketClient(id, webSocket, this);
      observer.onAccept(client).then((_) {
        webSocket.stream.listen((data) {
          /// Ignore strings
          /// TODO: send error bad request
          if (data is List<int>)
            client.notifyData(new ChannelData(client, data));
        });
      });
    });

    shelf_io.serve(handler, InternetAddress.ANY_IP_V4, port);
  }
}
