part of rebel_core;

/// Observes for accepted clients
abstract class ServerChannelObserver {
  /// On accept 
  Future<bool> onAccept(ServerChannelClient client);
}