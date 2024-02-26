abstract class StorageImpl {
  /// Initialize storage
  void init();

  /// Write data to storage
  Future<void> write({var key, var value});

  /// Read data from storage
  Future<String?> read({var key});

  /// Delete data from storage
  Future<void> delete({var key});

  /// Clear all data from storage
  Future<void> deleteAll();
}
