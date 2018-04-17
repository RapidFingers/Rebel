part of rebel_core;

/// Data from protocol
class ProtocolData {
  /// Channel client
  final ChannelClient channelClient;

  /// Full frame data
  final List<int> frameData;

  /// Constructor
  ProtocolData(this.channelClient, this.frameData);
}