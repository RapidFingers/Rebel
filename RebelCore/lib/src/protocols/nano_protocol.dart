part of rebel_core;

/// Protocol Id(UInt8) | ControlField(UInt8) | [Packet Number](UInt16) | Length(UInt16) | FrameData
/// Control Field:
/// 7 : 1 - is start packet
/// 6 : 1 - is end packet
/// If there is 7 and 6 bits then it's single packet, and has no packet number

/// State of NanoProtocol
enum NanoProtocolState {
  /// Start state
  Start,
  // Receive state
  Receive
}

/// Protocol for working over Websockets
class NanoProtocol extends Protocol {
  /// Max size of part
  static const MaxPartSize = 0xFFFF;

  /// Id of nano protocol
  static const ProtocolId = 0x0A;

  /// Minimal header size in bytes
  static const HeaderSize = 6;

  /// Buffer of packets
  final Queue<List<int>> _packetBuffer = new Queue<List<int>>();

  /// State of NanoProtocol
  NanoProtocolState _state;

  /// Buffer for receive
  final BinaryData _receiveBuffer = new BinaryData();

  /// Split packet to parts
  Iterable<BinaryData> _prepareParts(List<int> data) sync* {
    final partCount = (data.length / MaxPartSize).ceil();
    const PartSize = MaxPartSize - HeaderSize;

    for (var i = 0; i < partCount; i++) {
      final start = i * PartSize;
      var end = (i + 1) * PartSize;
      if (start + end > data.length)
        end = data.length - start;

      final packData = data.getRange(start, end).toList();
      final binary = new BinaryData();
      binary.writeUInt8(ProtocolId);
      var controlField = 0;
      if (i == 0)
        controlField = 0x80;
      if (i + 1 == partCount)
        controlField += 0x40;
      binary.writeUInt8(controlField);
      if (controlField & 0x40 == 0)
        binary.writeUInt8(i + 1);
      binary.writeUInt16(packData.length);
      binary.writeList(packData);
      yield binary;
    }
  }

  /// Send all packets
  Future _sendPackets() async {
    while (_packetBuffer.isNotEmpty) {
      final data = _packetBuffer.removeFirst();
      for (final part in _prepareParts(data)) {
        client.send(part.toData());
      }
    }
  }

  /// Reset state
  void _reset() {
    _state = NanoProtocolState.Start;
  }

  /// Constructor
  NanoProtocol(ChannelClient client) : super(client) {
    _reset();
  }

  /// Send data to channel
  @override
  Future send(List<int> data) async {
    if (_packetBuffer.isNotEmpty) {
      _packetBuffer.add(data);
    } else {
      _packetBuffer.add(data);
      _sendPackets();
    }
  }

  /// Process data from client
  @override
  void processData(ChannelData channelData) {
    _receiveBuffer.writeList(channelData.data);

    if (_state == NanoProtocolState.Start) {
      _receiveBuffer.setPos(0);
      if (_receiveBuffer.length < HeaderSize) return;
      final protocoId = _receiveBuffer.readUInt8();
      if (protocoId != ProtocolId) {
        _reset();
        return;
      }

      final controlField = _receiveBuffer.readUInt8();
      // Is single frame
      if (controlField & 0xC0 > 0) {
        final len = _receiveBuffer.readUInt16();
        if (len >= _receiveBuffer.length - HeaderSize) {
          /// TODO: read with remove
          final data = _receiveBuffer.readList(len);
          _frameController.add(new ProtocolData(channelData.client, data));
          _receiveBuffer.clear();
        } else {
          _state = NanoProtocolState.Receive;
          return;
        }
      }
    }    
  }
}
