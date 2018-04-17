part of rebel_server;

/// Message for add listener of message from client
class AddListenerMessage extends WorkerMessage {
  /// Client to listen
  final Client client;

  /// Port to send messages
  SendPort sendPort;

  /// Constructor
  AddListenerMessage(this.client, this.sendPort);
}