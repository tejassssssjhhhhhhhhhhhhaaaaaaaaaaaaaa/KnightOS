import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/design_system/design_constants.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';
import '../../domain/travel_ui_models.dart';

/// Presentation-only Visualization Engine for Travel Command Center.
/// Responsible for marker processing, route color mapping, and rendering logic.
class TravelVizEngine {
  const TravelVizEngine();

  /// Maps travel types to semantic colors based on KnightOS Horizon design.
  Color getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'flight':
        return DesignColors.accentCyan;
      case 'hotel':
        return DesignColors.accentPurple;
      case 'train':
      case 'rail':
        return DesignColors.warning;
      case 'bus':
      case 'road':
        return DesignColors.success;
      default:
        return DesignColors.accentBlue;
    }
  }

  /// Maps travel types to relevant icons.
  IconData getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'flight':
        return Icons.flight_takeoff_rounded;
      case 'hotel':
        return Icons.bed_rounded;
      case 'train':
      case 'rail':
        return Icons.train_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'road':
      case 'car':
        return Icons.directions_car_rounded;
      case 'photo':
        return Icons.photo_library_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  /// Generates a simple heat intensity based on visit frequency (simulated for Phase 1).
  double getHeatIntensity(int visitCount) {
    if (visitCount > 10) return 1.0;
    if (visitCount > 5) return 0.7;
    return 0.4;
  }

  /// Optimizes polyline points for rendering (e.g., removing redundant points).
  List<LatLng> optimizeRoute(List<LatLng> points) {
    if (points.length < 3) return points;
    return points;
  }

  /// Calculates center point for a set of coordinates.
  LatLng calculateCenter(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    double lat = 0;
    double lng = 0;
    for (final p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }

  /// Groups nearby locations into clusters based on zoom level.
  List<TravelCluster> clusterMarkers(List<TravelGeographicEnrichmentData> locations, double zoom) {
    if (locations.isEmpty) return [];
    
    final clusters = <TravelCluster>[];
    final clusterDistance = 100 / zoom;

    for (final loc in locations) {
      if (loc.latitude == null || loc.longitude == null) continue;
      
      bool addedToCluster = false;
      for (final cluster in clusters) {
        if (_isNearby(LatLng(loc.latitude!, loc.longitude!), cluster.center, clusterDistance)) {
          cluster.items.add(loc);
          addedToCluster = true;
          break;
        }
      }
      
      if (!addedToCluster) {
        clusters.add(TravelCluster(
          center: LatLng(loc.latitude!, loc.longitude!),
          items: [loc],
        ));
      }
    }
    return clusters;
  }

  bool _isNearby(LatLng p1, LatLng p2, double threshold) {
    final latDiff = (p1.latitude - p2.latitude).abs();
    final lngDiff = (p1.longitude - p2.longitude).abs();
    return (latDiff + lngDiff) < threshold;
  }
}
