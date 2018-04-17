part of rebel_core;

/// Data from channel client
class ChannelData {
  // Channel client
  final ChannelClient client;

  /// Data from client
  final List<int> data;

  /// Constructor
  ChannelData(this.client, this.data);
}