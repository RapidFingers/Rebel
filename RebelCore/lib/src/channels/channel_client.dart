part of rebel_core;

/// Client in channel for servers
abstract class ChannelClient extends DataNotifier {
  /// Send data to channel
  Future send(List<int> data);
}