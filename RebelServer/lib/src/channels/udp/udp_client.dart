part of rebel_server;

/// Client for udp channel
class UdpClient extends ServerChannelClient {
  /// Client address
  ClientAddress address;

  /// Constructor
  UdpClient(int clientId, this.address, ServerChannel channel) : super(clientId, channel);  
}