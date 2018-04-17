part of rebel_server;

/// Accepted client and gate between message processor and worker backend
/// Client can be sent to any other isolate
class Client {
  /// Port for sending messages to backend worker
  final SendPort _backPort;

  /// Get next request number
  final RequestCounter _counter;

  /// Client id
  final int clientId;

  /// Return next request id
  int _nextCounter() => _counter.getNext();

  /// Constructor
  Client(this.clientId, this._backPort) : _counter = new RequestCounter();

  /// Create client listener
  ClientListener listen(OnRequest onRequest) {
    return new ClientListener(this, onRequest);
  }

  /// Equal objects
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// Calc hash
  @override
  int get hashCode => clientId;
}
