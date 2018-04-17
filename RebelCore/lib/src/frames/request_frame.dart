part of rebel_core;

/// Request frame
class RequestFrame extends Frame {
  /// Request frame
  static const FrameId = 0x01;

  /// Id of request
  final int requestId;

  /// Constructor
  RequestFrame(this.requestId);
}