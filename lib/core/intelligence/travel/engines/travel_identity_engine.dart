import '../../domain/travel_models.dart';

/// Resolves ownership of every travel record.
/// Categories: My Travel, Family Travel, Shared Travel, Unknown.
class TravelIdentityEngine {
  /// Determines the identity (ownership) of a travel record.
  /// Uses passenger names, booking references, email recipient, and historical patterns.
  Future<TravelIdentity> resolve({
    required Map<String, dynamic> metadata,
    String? userName,
    List<String>? familyNames,
  }) async {
    final passengers = metadata['passengers'] as List<dynamic>?;
    final recipient = metadata['recipient'] as String?;
    
    // 1. Check Passenger List
    if (passengers != null && passengers.isNotEmpty) {
      final passengerNames = passengers.map((p) => p.toString().toLowerCase()).toList();
      final lowerUserName = userName?.toLowerCase();

      if (lowerUserName != null && passengerNames.contains(lowerUserName)) {
        if (passengerNames.length == 1) {
          return TravelIdentity.myTravel;
        }
        
        final lowerFamilyNames = familyNames?.map((f) => f.toLowerCase()).toList() ?? [];
        final hasFamily = passengerNames.any((name) => name != lowerUserName && lowerFamilyNames.contains(name));
        
        return hasFamily ? TravelIdentity.familyTravel : TravelIdentity.sharedTravel;
      }
    }

    // 2. Check Email Recipient (if available)
    if (recipient != null && userName != null && recipient.toLowerCase().contains(userName.toLowerCase())) {
      // If it's sent to the user, and no other passengers are listed, assume My Travel for now
      if (passengers == null || passengers.isEmpty) {
        return TravelIdentity.myTravel;
      }
    }

    // 3. Historical Patterns (Placeholder for future enrichment)
    
    return TravelIdentity.unknown;
  }
}
