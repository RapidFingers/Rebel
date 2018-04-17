part of rebel_server;

/// Send port for receiving messages
class SendPortMessage extends WorkerMessage {
  /// Send port
  final SendPort sendPort;

  /// Constructor
  SendPortMessage(this.sendPort);
}