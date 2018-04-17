part of rebel_server;

/// Set settings to backend
class SendSettingsMessage extends WorkerMessage {
  /// Transforms body of frame
  final BodyTransformer bodyTransformer;

  /// Settings
  final Set<ChannelSettings> channelSettings;

  /// Logger
  final Logger logger;

  /// Constructor
  SendSettingsMessage(this.bodyTransformer, this.channelSettings, this.logger);
}