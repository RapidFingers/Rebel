part of rebel_core;

/// Packet body that can be serialize to some binary data
abstract class SerializableBody extends FrameBody {
  /// Pack to some data
  List<int> pack();

  /// Unpack some data to body fields
  void unpack(List<int> data);
}