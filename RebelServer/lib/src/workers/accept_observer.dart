part of rebel_server;

/// Observe for new client
abstract class AcceptObserver {
  /// On accepted client
  /// If result is false - then client is ignored
  Future<ClientListener> onAccept(Client client);
}