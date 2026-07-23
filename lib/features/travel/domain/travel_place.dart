/// Immutable travel place model for the KnightOS travel module.
class TravelPlace {
  const TravelPlace({
    required this.id,
    required this.name,
    required this.type,
    required this.country,
    required this.state,
    required this.city,
    required this.description,
    required this.status,
    this.visitDate,
    this.notes = '',
    this.rating = 0.0,
    this.isFavorite = false,
  });

  final String id;
  final String name;
  final TravelPlaceType type;
  final String country;
  final String state;
  final String city;
  final String description;
  final TravelPlaceStatus status;
  final String? visitDate;
  final String notes;
  final double rating;
  final bool isFavorite;

  TravelPlace copyWith({
    String? id,
    String? name,
    TravelPlaceType? type,
    String? country,
    String? state,
    String? city,
    String? description,
    TravelPlaceStatus? status,
    String? visitDate,
    String? notes,
    double? rating,
    bool? isFavorite,
  }) {
    return TravelPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      description: description ?? this.description,
      status: status ?? this.status,
      visitDate: visitDate ?? this.visitDate,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory TravelPlace.fromJson(Map<String, Object?> json) {
    final typeValue = json['type'] as String?;
    final statusValue = json['status'] as String?;
    return TravelPlace(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: typeValue == 'state'
          ? TravelPlaceType.state
          : typeValue == 'city'
              ? TravelPlaceType.city
              : typeValue == 'touristPlace'
                  ? TravelPlaceType.touristPlace
                  : TravelPlaceType.country,
      country: json['country'] as String? ?? '',
      state: json['state'] as String? ?? '',
      city: json['city'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: statusValue == 'wishlist'
          ? TravelPlaceStatus.wishlist
          : statusValue == 'planned'
              ? TravelPlaceStatus.planned
              : TravelPlaceStatus.visited,
      visitDate: json['visitDate'] as String?,
      notes: json['notes'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'type': type.name,
      'country': country,
      'state': state,
      'city': city,
      'description': description,
      'status': status.name,
      'visitDate': visitDate,
      'notes': notes,
      'rating': rating,
      'isFavorite': isFavorite,
    };
  }
}

enum TravelPlaceType {
  country,
  state,
  city,
  touristPlace,
}

extension TravelPlaceTypeLabel on TravelPlaceType {
  String get label {
    switch (this) {
      case TravelPlaceType.country:
        return 'Country';
      case TravelPlaceType.state:
        return 'State';
      case TravelPlaceType.city:
        return 'City';
      case TravelPlaceType.touristPlace:
        return 'Tourist Place';
    }
  }
}

enum TravelPlaceStatus {
  visited,
  wishlist,
  planned,
}

extension TravelPlaceStatusLabel on TravelPlaceStatus {
  String get label {
    switch (this) {
      case TravelPlaceStatus.visited:
        return 'Visited';
      case TravelPlaceStatus.wishlist:
        return 'Wishlist';
      case TravelPlaceStatus.planned:
        return 'Planned';
    }
  }
}
