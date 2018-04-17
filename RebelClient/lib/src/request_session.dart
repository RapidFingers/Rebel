part of rebel_client;

/// Session for request sending
class RequestSession {
  /// To complete send on receiving response
  final Completer<Response> sendCompleter = new Completer();

  /// Request
  final RequestFrame request;

  /// Constructor
  RequestSession(this.request);
}