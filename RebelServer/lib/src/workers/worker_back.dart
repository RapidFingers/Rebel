part of rebel_server;

/// Internal Client data for backend
class ClientInternal {
  /// Client
  Client client;

  /// Client to send through channel
  ServerChannelClient channelClient;

  /// Protocol to send data
  Protocol protocol;

  /// Port of listener
  SendPort listenerPort;

  /// To complete accept
  Completer<bool> acceptCompleter;

  /// Constructor
  ClientInternal(this.client, this.channelClient, this.protocol, this.acceptCompleter);
}

/// Backend for worker
class WorkerBack implements ServerChannelObserver {
  /// For receiving messages from WorkerFront
  ReceivePort _receivePort;

  /// Port for sending messages to frontend worker
  SendPort _frontPort;

  /// Working channels
  List<ServerChannel> _channels;

  /// Clients by id
  Map<int, ClientInternal> _clientsById;

  /// Transforms frames
  FrameTransformer _frameTransformer;

  /// Logger
  Logger _logger;

  /// Entry point with start [message]
  static void create(WorkerMessage message) async {
    var worker = new WorkerBack._internal();
    await worker._process(message);
  }
  /// Validate frame
  bool _isValidFrame(Frame frame) {
    if (frame == null || frame.body == null) return false;
    return true;
  }

  /// Constructor
  WorkerBack._internal() {
    _channels = new List<ServerChannel>();
    _clientsById = new Map<int, ClientInternal>();
  }

  /// Process message
  void _process(WorkerMessage message) async {
    if (message is SendPortMessage) {
      await _processSendPort(message);
    } else if (message is SendSettingsMessage) {
      await _processFrontSettings(message);
    } else if (message is PacketMessage) {
      await _processSendData(message);
    } else if (message is AddListenerMessage) {
      await _processAddClientListener(message);
    }
  }

  /// Process send port
  void _processSendPort(SendPortMessage message) async {
    _frontPort = message.sendPort;
    _receivePort = new ReceivePort();
    _receivePort.cast<WorkerMessage>().listen(_process);
    _frontPort.send(new SendPortMessage(_receivePort.sendPort));
  }

  /// Process settings from frontend
  void _processFrontSettings(SendSettingsMessage message) async {
    _frameTransformer = new FrameTransformer(message.bodyTransformer);
    for (final chanSettings in message.channelSettings) {
      ServerChannel channel;
      switch (chanSettings.channelType) {
        case ChannelType.Udp:
          channel = new UdpChannel(chanSettings.port, this);
          break;
        case ChannelType.Tcp:
          channel = new TcpChannel(chanSettings.port, this);
          break;
        case ChannelType.Websocket:
          channel = new WebsocketChannel(chanSettings.port, this);
          break;
        default:
          throw new RebelException("Unknown channel type");
      }
      _channels.add(channel);
      await channel.start();
    }

    _logger = message.logger;
    _frontPort.send(new ReadyForWorkMessage());
  }

  /// Add client message listener
  void _processAddClientListener(AddListenerMessage message) {
    var clientInternal = _clientsById[message.client.clientId];
    if (clientInternal == null) {
      clientInternal.acceptCompleter.complete(false);
      return;
    }

    if (message.sendPort == null) {
      clientInternal.acceptCompleter.complete(false);
      return;
    }

    clientInternal.listenerPort = message.sendPort;
    clientInternal.acceptCompleter.complete(true);
  }

  /// Send data to channel
  void _processSendData(PacketMessage message) async {
    final clientId = message.client.clientId;
    var clientInternal = _clientsById[clientId];
    final frame = message.frame;
    final data = _frameTransformer.pack(frame);

    if (clientInternal != null) {
      final protocol = clientInternal.protocol;
      protocol.send(data);
    }
  }

  /// On client accepted
  @override
  Future<bool> onAccept(ServerChannelClient client) async {
    final acceptCompleter = new Completer<bool>();

    final clientId = client.clientId;
    final frontClient = new Client(clientId, _receivePort.sendPort);
      final protocol = new NanoProtocol(client);

    protocol.onFrame.listen(_onFrame);
    
    final newClientInternal = new ClientInternal(
          frontClient, client, protocol, acceptCompleter);

    _clientsById[clientId] = newClientInternal;
    _frontPort.send(new AcceptMessage(frontClient));    

    return acceptCompleter.future;
  }
  
  /// On frame
  void _onFrame(ProtocolData data) {
    final ServerChannelClient client = data.channelClient;
    final clientId = client.clientId;
    final clientInternal = _clientsById[clientId];
    final frame = _frameTransformer.unpack(data.frameData);
    if (!_isValidFrame(frame)) {
      _logger.addLine("Invalid frame");
      return;
    }

    // Accept
    if (clientInternal != null) {
      clientInternal.listenerPort
          ?.send(new PacketMessage(clientInternal.client, frame));
    }
  }  
}
