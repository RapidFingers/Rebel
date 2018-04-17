part of rebel_server;

/// Websocket channel
class TcpChannel extends ServerChannel {
  /// Constructor
  TcpChannel(int port, ServerChannelObserver observer) : super(port, observer);

  /// Send data to client
  @override
  Future send(ChannelClient client, List<int> data) async {
    if (client is TcpClient) {
      client.socket.add(data);
    }
  }

  /// Start listen
  @override
  Future start() async {
    var socket = await ServerSocket.bind(InternetAddress.ANY_IP_V4, port);
    socket.listen((Socket clientSocket) {
      var id = uuidGenerator.v4().hashCode;
      final client = new TcpClient(id, clientSocket, this);
      observer.onAccept(client).then((needListen) {
        if (needListen) {
          clientSocket.listen((data) {
            client.notifyData(new ChannelData(client, data));
          });
        }
      });
    });
  }
}
