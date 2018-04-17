part of rebel_server;

/// Udp channel for send/receive packets
class UdpChannel extends ServerChannel {
  /// Maximal packet size for channel
  static const MaxPacketSize = 400;

  /// Udp socket
  RawDatagramSocket _socket;

  /// Constructor
  UdpChannel(int port, ServerChannelObserver observer) : super(port, observer);

  /// Send some binary data to client
  @override
  Future send(ChannelClient client, List<int> data) async {
    if (client is UdpClient) {
      _socket.send(data, client.address.host, client.address.port);
    }
  }

  /// Return stream for accept
  /*@override
  Stream<ChannelData> get onData {
    RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, port).then((sock) {
      _socket = sock;
      _socket.listen((RawSocketEvent event) async {
        final datagram = await _socket.receive();
        if (datagram != null) {
          final address = new ClientAddress(datagram.address, datagram.port);

          //final udpClient = new UdpClient(address.hashCode, address, this);
          //dataController.add(new ChannelData(udpClient, datagram.data));
        }
      });
    });

    return dataController.stream;
  }*/

  /// Start listen
  @override
  Future start() async {
    
  }  
}
