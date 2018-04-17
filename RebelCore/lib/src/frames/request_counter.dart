part of rebel_core;

/// For get new request number
class RequestCounter {
  /// Request counter
  int _requestCounter = 0;

  // Get next counter
  int getNext() {
    _requestCounter += 1;
    if (_requestCounter > 0xFFFF) _requestCounter = 1;
    return _requestCounter;
  }
}