class Place {
  const Place({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.category,
    this.tags = const [],
    this.metadata = const {},
  });

  final String id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? category;
  final List<String> tags;
  final Map<String, dynamic> metadata;
}
