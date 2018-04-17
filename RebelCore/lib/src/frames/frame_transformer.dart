part of rebel_core;

/// Converts frame to and from bytes
class FrameTransformer {
  /// Body transformer
  BodyTransformer _bodyTransformer;

  /// Constructor
  FrameTransformer(this._bodyTransformer);

  /// Pack frame to binary
  List<int> pack(Frame frame) {
    // TODO: catch exceptions

    var binary = new BinaryData();
    final packetData = frame.body != null ? _bodyTransformer.pack(frame.body) : null;
    if (frame is RequestFrame) {
      binary.writeUInt8(RequestFrame.FrameId);
      binary.writeUInt16(frame.requestId);
      if (packetData == null)
        throw new RebelException("Wrong request body");
      binary.writeList(packetData);
      return binary.toData();
    }

    if (frame is ResponseFrame) {
      binary.writeUInt8(ResponseFrame.FrameId);
      binary.writeUInt16(frame.requestId);
      binary.writeUInt8(frame.code);
      if (packetData != null)
        binary.writeList(packetData);
      return binary.toData();
    }

    if (frame is StreamFrame) {
      var binary = new BinaryData();
      binary.writeUInt8(RequestFrame.FrameId);
      binary.writeList(packetData);
      return binary.toData();
    }

    throw new RebelException("Unknown frame type");
  }

  /// Unpack binary data to frame
  Frame unpack(List<int> data) {
    final binary = new BinaryData.fromList(data);
    final frameId = binary.readUInt8();
    if ((frameId < RequestFrame.FrameId) || (frameId > StreamFrame.FrameId))
      return null;

    Frame frame = null;

    switch (frameId) {
      case RequestFrame.FrameId:
        frame = new RequestFrame(binary.readUInt16());
        break;
      case ResponseFrame.FrameId:
        frame = new ResponseFrame(binary.readUInt16(), binary.readUInt8());
        break;
      case StreamFrame.FrameId:
        frame = new StreamFrame();
        break;
      default:
        return null;
    }

    if (binary.remain > 0) {
      frame.body = _bodyTransformer.unpack(binary.readList());
    }
    return frame;
  }
}
