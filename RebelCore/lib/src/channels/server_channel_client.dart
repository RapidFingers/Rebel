part of rebel_core;

/// Channel client for server side
abstract class ServerChannelClient extends ChannelClient {
  /// Client id to identify client
  final int clientId;

  /// Channel to send data
  final ServerChannel channel;

  /// Constructor
  ServerChannelClient(this.clientId, this.channel);

  /// Send data through channel
  @override
  Future send(List<int> data) async {
    channel.send(this, data);
  }
}