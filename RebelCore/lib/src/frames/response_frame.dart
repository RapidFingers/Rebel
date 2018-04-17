part of rebel_core;

/// Response frame
class ResponseFrame extends Frame {
  /// Response frame
  static const FrameId = 0x02;

  /// Id of request
  final int requestId;

  /// Response code
  final int code;

  /// Constructor
  ResponseFrame(this.requestId, this.code);
}