part of rebel_client;

/// Call on request from server
typedef Future<SerializableBody> OnRequest(SerializableBody request);

/// Base client
abstract class RebelClient implements ClientChannel {
  /// To get request number
  final RequestCounter _counter = new RequestCounter();

  /// Sessions
  final Map<int, RequestSession> _sessions = new Map<int, RequestSession>();

  /// Protocol
  Protocol protocol;

  /// Client observer
  //final ClientChannelObserver observer;

  /// Call on request
  OnRequest onRequest;

  /// Converts body from and to bytes
  final FrameTransformer frameTransformer;

  /// Constructor
  RebelClient(BodyTransformer bodyTransformer) : frameTransformer = new FrameTransformer(bodyTransformer);

  /// Connect to server
  Future<void> connect();

  /// Send frame to server and wait for response
  Future<Response> sendRequest(SerializableBody body);

  /// Create new request with next counter
  RequestSession createRequestSession(SerializableBody body) {
    final request = new RequestFrame(_counter.getNext());
    request.body = body;
    final requestSession = new RequestSession(request);
    _sessions[request.requestId] =  requestSession;
    return requestSession;
  }
}
