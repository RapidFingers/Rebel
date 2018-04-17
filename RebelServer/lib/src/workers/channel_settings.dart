part of rebel_server;

/// Channel settings
class ChannelSettings {
  /// Channel type
  final ChannelType channelType;

  /// Port
  final int port;

  /// Constructor
  ChannelSettings(this.channelType, this.port);

  /// Equals objects
  @override
  bool operator ==(Object other) =>
      hashCode == other.hashCode;

  /// Calc hashcode
  @override
  int get hashCode => channelType.hashCode ^ port;
}