part of rebel_server;

/// On receive response timeout
class TimeoutMessage extends WorkerMessage {
  /// Client
  int clientId;

  /// Constructor
  TimeoutMessage(this.clientId);
}