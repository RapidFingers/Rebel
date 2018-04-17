part of rebel_core;

/// Channel on client side
abstract class ClientChannel {
  /// Connect to server
  Future<void> connect();

  /// Send frame to server and wait for response
  Future<Response> sendRequest(SerializableBody body);
}