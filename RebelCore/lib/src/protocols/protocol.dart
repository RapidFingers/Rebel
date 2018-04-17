part of rebel_core;

/// Transport protocol
abstract class Protocol {
  /// For streaming accepted clients
  StreamController<ProtocolData> _frameController = new StreamController<ProtocolData>();

  /// Some output to send data
  ChannelClient client;  

  /// On frame
  Stream<ProtocolData> get onFrame => _frameController.stream;

  /// Constructor
  Protocol(this.client) {
    client.onData.listen(processData);
  }
  
  /// Send data to channel
  Future<void> send(List<int> data);

  /// Process data from client
  void processData(ChannelData data) {
    print(data);
  }
}