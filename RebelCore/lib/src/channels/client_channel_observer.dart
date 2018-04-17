part of rebel_core;

/// Observer for rebel client events
abstract class ClientChannelObserver {
  /// On push requests from server
  /// Returns body response
  Future<SerializableBody> onRequest(SerializableBody requestBody);
}