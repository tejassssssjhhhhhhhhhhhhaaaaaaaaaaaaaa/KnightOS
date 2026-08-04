import 'dart:io';
import 'package:mocktail/mocktail.dart';
import 'package:knight_os/core/intelligence/domain/knight_memory.dart';
import 'package:knight_os/core/intelligence/domain/memory_metadata.dart';
import 'package:knight_os/core/intelligence/domain/memory_version.dart';
import 'package:knight_os/core/intelligence/domain/intelligence_events.dart';
import 'package:knight_os/core/intelligence/knight_context_models.dart';

class FakeFile extends Fake implements File {}
class FakeKnightMemory extends Fake implements KnightMemory {}
class FakeMemoryMetadata extends Fake implements MemoryMetadata {}
class FakeMemoryVersion extends Fake implements MemoryVersion {}
class FakeIntelligenceEvent extends Fake implements IntelligenceEvent {}
class FakeKnightContext extends Fake implements KnightContext {}

void setupMocktailFallbacks() {
  registerFallbackValue(FakeFile());
  registerFallbackValue(FakeKnightMemory());
  registerFallbackValue(FakeMemoryMetadata());
  registerFallbackValue(FakeMemoryVersion());
  registerFallbackValue(FakeIntelligenceEvent());
  registerFallbackValue(FakeKnightContext());
  registerFallbackValue(DateTime.now());
}
