part of rebel_core;

/// Notify for data from channel
abstract class DataNotifier {
  /// For streaming accepted data
  StreamController<ChannelData> dataController = new StreamController<ChannelData>();
  
  /// Get stream for data
  Stream<ChannelData> get onData => dataController.stream;

  /// Notify for data
  void notifyData(ChannelData data) {
    dataController.add(data);
  }
}