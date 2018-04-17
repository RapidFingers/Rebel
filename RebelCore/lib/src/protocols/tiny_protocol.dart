part of rebel_core;

/// Protocol Id | ControlField | [Packet Number] | FrameData
/// Control Field:
/// 7 : 1 - is start packet
/// 6 : 1 - is end packet

enum TiniProtocolState {
  /// Start state
  Start,
  /// Work state
  Work
}

/// Protocol for working over UDP
class TinyProtocol extends Protocol {  
  /// Protocol state
  TiniProtocolState _state;



  /// Buffer for packet
  final BinaryData _binaryData = new BinaryData();

  /// Reset all
  void _reset() {
    _state = TiniProtocolState.Start;
    _binaryData.clear();
  }

  /// Constructor
  TinyProtocol(ChannelClient channel) : super(channel) {
    _reset();
  }

  /// Send data to channel
  @override
  Future send(List<int> data) async {
    // TODO: implement send
  }

  /// Process data from client
  @override
  void processData(ChannelData channelData) {
    switch(_state) {
      case TiniProtocolState.Start:
        final bd = new BinaryData.fromList(channelData.data);
        final protocolId = bd.readUInt8();
        final controlField = bd.readUInt8();

        break;
      case TiniProtocolState.Work:
        break;
    }
  }  
}