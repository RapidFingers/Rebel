part of rebel_server;

/// On client accept
class AcceptMessage extends WorkerMessage {
  /// Accepted client
  final Client client;

  /// Constructor
  AcceptMessage(this.client);
}