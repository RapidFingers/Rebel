part of rebel_core;

/// Logger message
abstract class _LoggerMessage {}

/// Send port to backend
class _LoggerSendPortMessage extends _LoggerMessage {
  /// Front send port
  final SendPort sendPort;

  /// Constructor
  _LoggerSendPortMessage(this.sendPort);
}

/// Logger backend
class _LoggerBack {
  /// Port to front end
  SendPort _frontPort;

  /// Port for receive
  ReceivePort _receivePort;

  /// Entry point with start [message]
  static void create(_LoggerMessage message) async {
    var worker = new _LoggerBack._internal();
    await worker._process(message);
  }

  /// Process logger message
  void _process(dynamic message) {
    if (message is _LoggerSendPortMessage) {
      _frontPort = message.sendPort;
      _receivePort = new ReceivePort();
      _receivePort.listen(_process);
      _frontPort.send(new _LoggerSendPortMessage(_receivePort.sendPort));
    } else if (message is String) {
      print(message);
    }
  }

  /// Private constructor
  _LoggerBack._internal();
}

/// Logger
class Logger {
  /// Port to send data to backend
  final SendPort _sendPort;

  /// Is debug
  final bool debug;

  /// Constructor
  Logger(this._sendPort, { this.debug : false });

  /// Add line to log
  void addLine(String data) {
    if (debug)
      _sendPort.send(data);
  }
}

/// Logger factory
class LoggerFactory {
  /// Init completer
  Completer<Logger> _initCompleter;

  /// Port to send data to backend
  SendPort _sendPort;

  /// Instance of logger factory
  static LoggerFactory _instance = new LoggerFactory();

  /// Is debug
  bool debug;

  /// Process logger message
  void _process(_LoggerMessage message) {
    if (message is _LoggerSendPortMessage) {
      _sendPort = message.sendPort;
      final logger = new Logger(_sendPort, debug : _instance.debug);
      _initCompleter.complete(logger);
    }
  }

  /// Create logger instance
  static Future<Logger> create({ debug : false}) async {
    _instance.debug = debug;
    if (_instance._sendPort == null) {
      _instance._initCompleter = new Completer();
      final receivePort = new ReceivePort();
      receivePort.cast<_LoggerMessage>().listen(_instance._process);
      await Isolate.spawn(_LoggerBack.create, new _LoggerSendPortMessage(receivePort.sendPort));
      return _instance._initCompleter.future;
    } else {
      return new Logger(_instance._sendPort, debug: _instance.debug);
    }
  }
}