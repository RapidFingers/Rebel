part of rebel_server;

/// Message with data from client
class PacketMessage extends WorkerMessage {
  /// Object with client identification
  final Client client;

  /// Some packet from client or to client
  final Frame frame;

  /// Constructor
  PacketMessage(this.client, this.frame);
}