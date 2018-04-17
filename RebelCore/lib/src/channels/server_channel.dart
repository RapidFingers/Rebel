part of rebel_core;

/// For send/receive packets though channel
abstract class ServerChannel {  
  /// Observer of server channel
  final ServerChannelObserver observer;

  /// Listen port
  final int port;

  /// For client id generation
  final Uuid uuidGenerator;

  /// Constructor
  ServerChannel(this.port, this.observer)
      : uuidGenerator = new Uuid();

  /// Send some data
  Future send(ChannelClient client, List<int> frame);  

  /// Start to listen
  Future start();
}
