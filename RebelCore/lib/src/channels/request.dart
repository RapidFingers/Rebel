part of rebel_core;

/// Request info for using in message processors
class Request {
  final int requestId;

  /// Request body
  final SerializableBody body;

  /// Constructor
  Request(this.requestId, this.body);
}