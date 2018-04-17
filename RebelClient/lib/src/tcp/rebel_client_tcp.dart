part of rebel_client;

/// Tcp client for rebel server
/// Works on Dart VM and Flutter
class RebelClientTcp extends RebelClient {
  /// Socket
  ChannelClientTcp _channelClient;

  /// Address to
  final dynamic address;

  /// Port to server
  final int port;

  /// Process frame data
  void _processFrame(ProtocolData protocolData) {
    final frame = frameTransformer.unpack(protocolData.frameData);
    if (frame is ResponseFrame) {
      final session = _sessions[frame.requestId];
      if (session != null) {
        session.sendCompleter.complete(new Response(frame.body, code: frame.code));
      }
    }
  }

  /// Constructor
  RebelClientTcp(this.address, this.port, BodyTransformer bodyTransformer) : super(bodyTransformer);

  /// Connect to server
  @override
  Future<void> connect() async {
    final socket = await Socket.connect(address, port);
    _channelClient = new ChannelClientTcp(socket);
    protocol = new NanoProtocol(_channelClient);
    protocol.onFrame.listen(_processFrame);
  }

  /// Send frame to server and wait for response
  @override
  Future<Response> sendRequest(SerializableBody body) async {
    final session = createRequestSession(body);
    final data = frameTransformer.pack(session.request);
    await protocol.send(data);
    return session.sendCompleter.future;
  }
}