part of rebel_server;

/// Function for create packet
typedef List<int> PacketCreatorFunc();

/// Registration for packet
class PacketCreator {
  /// Id of packet
  final int id;

  /// Packet create function
  final PacketCreatorFunc create;

  /// Constructor
  PacketCreator(this.id, this.create);
}

/// Main class of game server
class RebelServer {
  /// Default max workers
  static const DefaultMaxWorkers = 1;

  /// Logger for all workers
  Logger _logger;

  /// Main worker
  WorkerFront _mainWorker;

  /// Observe incoming clients
  final AcceptObserver _acceptObserver;

  /// Transforms packets
  final BodyTransformer _bodyTransformer;

  /// Channel settings
  final Set<ChannelSettings> _channelSettings = new Set<ChannelSettings>();

  /// Max workers
  int maxWorkers;

  /// Write debug messages
  bool debug = false;

  /// Constructor
  RebelServer(this._acceptObserver, this._bodyTransformer) {
    maxWorkers = DefaultMaxWorkers;
  }

  /// Add udp channel
  void addUdpChannel(int port) {
    _channelSettings.add(new ChannelSettings(ChannelType.Udp, port));
  }

  /// Add tcp channel
  void addTcpChannel(int port) {
    _channelSettings.add(new ChannelSettings(ChannelType.Tcp, port));
  }

  /// Add websocket channel
  void addWebsocketChannel(int port) {
    _channelSettings.add(new ChannelSettings(ChannelType.Websocket, port));
  }

  /// Start listen
  /// Need call after configure and registerPacket
  Future start() async {
    _logger = await LoggerFactory.create(debug : this.debug);

    // Start main worker
    if (_channelSettings.length < 1)
      throw new RebelException("No channels");
    _mainWorker = new WorkerFront(_acceptObserver, _bodyTransformer, _channelSettings, _logger);
    await _mainWorker.start();
  }
}
