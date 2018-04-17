part of rebel_core;

/// Info about client
class ClientAddress {
  /// Client address
  final InternetAddress host;

  /// Port of client
  final int port;

  /// Constructor
  ClientAddress(this.host, this.port);

  /// Equal objects
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// Calculate hash
  @override
  int get hashCode => host.hashCode ^ port.hashCode;
}