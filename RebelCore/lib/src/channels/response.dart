part of rebel_core;

/// Request info for using in message processors
class Response {
  /// Response code
  final int code;

  /// Request body
  final SerializableBody body;

  /// Constructor
  Response(this.body, { this.code : ResponseCode.Ok });
}