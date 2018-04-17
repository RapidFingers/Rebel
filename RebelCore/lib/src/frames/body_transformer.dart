part of rebel_core;

/// Base packet transformer interface
abstract class BodyTransformer {
  /// Pack to binary data
  List<int> pack(SerializableBody packet);

  /// Unpack from binary data
  SerializableBody unpack(List<int> data);
}