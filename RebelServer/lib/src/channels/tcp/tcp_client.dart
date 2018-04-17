part of rebel_server;

/// Client for udp channel
class TcpClient extends ServerChannelClient {
  /// Socket
  final Socket socket;

  /// Constructor
  TcpClient(int clientId, this.socket, ServerChannel channel) : super(clientId, channel);
}