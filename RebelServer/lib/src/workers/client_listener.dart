part of rebel_server;

/// On packet call
typedef Future<Response> OnRequest(Request message);

/// On timeout
typedef void OnTimeout();

/// For receive and send packets to client
class ClientListener {
  /// Subscription for messages from backend
  StreamSubscription<PacketMessage> _subscription;

  /// Client
  Client _client;

  /// Port for receiving messages
  ReceivePort _receivePort;

  /// Completers. RequestId -> Completer
  Map<int, Completer<Response>> _completers;

  /// On request packet
  OnRequest onRequest;

  /// On timeout
  OnTimeout onTimeout;

  /// Constructor
  ClientListener(this._client, this.onRequest) {
    _completers = new Map<int, Completer<Response>>();
  }

  /// Send response
  void _sendResponse(ResponseFrame response) {
    _client._backPort.send(new PacketMessage(_client, response));
  }

  /// Add listener for messages
  StreamSubscription<PacketMessage> listen() {
    if (_subscription != null)
      return _subscription;

    _receivePort = new ReceivePort();
    _client._backPort.send(new AddListenerMessage(_client, _receivePort.sendPort));
    // Catch errors and send internal error
    _subscription = _receivePort.cast<WorkerMessage>().listen((message) {
      if (message is PacketMessage) {
        final packet = message.frame;
        if (packet is ResponseFrame) {
          final completer = _completers[packet.requestId];
          completer?.complete(new Response(packet.body, code : packet.code));
        } else if (packet is RequestFrame) {
          onRequest(new Request(packet.requestId, packet.body)).then((resp) {
            // TODO: send response with not supported
            //if (body == null)
            //  throw new MessageServerException("");
            if (resp != null) {
              var response = new ResponseFrame(packet.requestId, resp.code);
              response.body = resp.body;
              _sendResponse(response);
            } else {
              var response = new ResponseFrame(packet.requestId, ResponseCode.Ok);
              _sendResponse(response);
            }
          });
        }
      } else {
        if (onTimeout != null)
          onTimeout();
      }
    });
    return _subscription;
  }

  /// Send packet to client
  Future<Response> sendRequest(Request packet) async {
    var completer = new Completer<Response>();
    var request = new RequestFrame(_client._nextCounter());
    request.body = packet.body;

    _completers[request.requestId] = completer;
    _client._backPort.send(new PacketMessage(_client, request));
    return completer.future;
  }
}