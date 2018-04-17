part of rebel_server;

/// On start complete callback
typedef void OnStartComplete(WorkerFront worker);

///TODO: Ping and timeout
/// Controller for worker backend
class WorkerFront {
  /// On start complete
  //OnStartComplete _onStartComplete;

  /// For complete sendSettings
  Completer _startCompleter = new Completer();

  /// Observe clients data
  AcceptObserver _acceptObserver;

  /// Transforms packets
  BodyTransformer _bodyTransformer;

  /// Port for sending messages to backend worker
  SendPort _backPort;

  /// Channel settings
  final Set<ChannelSettings> _channelSettings;

  /// Logger
  final Logger _logger;

  /// Constructor
  WorkerFront(this._acceptObserver, this._bodyTransformer, this._channelSettings, this._logger);

  /// Process messages from backend
  void _process(WorkerMessage message) async {
    if (message is SendPortMessage) {
      _backPort = message.sendPort;
      setup();
    } else if (message is ReadyForWorkMessage) {
      _startCompleter.complete();
    }
    else if (message is AcceptMessage) {
      final listener = await _acceptObserver.onAccept(message.client);
      listener.listen();

      if (listener == null) {
        // Send AddListenerMessage with "send port" null to ignore client
        message.client._backPort.send(new AddListenerMessage(message.client, null));
      }
    }
  }

  /// Send settings to backend
  void setup() {
    _backPort.send(new SendSettingsMessage(_bodyTransformer, _channelSettings, _logger));
  }

  /// Start worker
  Future start() async {
    final receivePort = new ReceivePort();
    receivePort.cast<WorkerMessage>().listen(_process);
    await Isolate.spawn<WorkerMessage>(WorkerBack.create, new SendPortMessage(receivePort.sendPort));
    return _startCompleter.future;
  }

  /// Stop worker
  void stop() {}
}
