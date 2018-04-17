part of rebel_core;

class RebelException implements Exception {
  /// Exception message
  final String message;

  /// Constructor
  RebelException(this.message);
}