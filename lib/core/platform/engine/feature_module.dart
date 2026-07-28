/// Generic feature-module platform contract for KnightOS.
///
/// This file re-exports the core feature-module contract so future modules can
/// import a stable engine-facing type without introducing additional engine
/// dependencies.
library;

export 'engine_interfaces.dart' show KnightFeatureModule;
