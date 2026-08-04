# KnightOS Provider SDK

## Overview
The Provider SDK allows developers to add new data connectors (e.g., Spotify, Tesla, Local Bank) to KnightOS.

## Implementation Steps

### 1. Define the Connector
Implement the `KnightConnector` interface.
```dart
class MyServiceConnector extends KnightConnector {
  @override
  String get id => 'my_service';
  
  @override
  Future<List<MemoryFragment>> fetch() async { ... }
}
```

### 2. Map Data to Memories
Use the `MemoryMapper` to transform raw JSON into canonical `MemoryTable` entries.

### 3. Register the Provider
Add the connector to the `IntelligencePlatform` registry.

## Security
Providers must use the `SecureStorageService` for all credentials and tokens.
