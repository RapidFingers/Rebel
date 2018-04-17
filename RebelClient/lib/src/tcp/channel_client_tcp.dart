part of rebel_client;

/// Client for tcp
class ChannelClientTcp extends ChannelClient {
  /// TCP Socket
  Socket _socket;

  /// Process data from socket
  void _processData(List<int> data) {
    dataController.add(new ChannelData(this, data));
  }

  /// Constructor
  ChannelClientTcp(this._socket) {
    _socket.listen(_processData);
  }

  /// Send data
  @override
  Future send(List<int> data) async {
    _socket.add(data);
  }
}