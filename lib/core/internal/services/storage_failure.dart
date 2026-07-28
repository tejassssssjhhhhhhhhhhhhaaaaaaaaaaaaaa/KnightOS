import 'package:flutter/foundation.dart';

@immutable
abstract class StorageFailure {
  const StorageFailure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseInitializationFailure extends StorageFailure {
  const DatabaseInitializationFailure(super.message);
}

class WriteFailure extends StorageFailure {
  const WriteFailure(super.message);
}

class ReadFailure extends StorageFailure {
  const ReadFailure(super.message);
}

class MigrationFailure extends StorageFailure {
  const MigrationFailure(super.message);
}
