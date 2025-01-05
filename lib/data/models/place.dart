class Place {
  final String id;
  final String name;
  final String governorate;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Place({
    required this.id,
    required this.name,
    required this.governorate,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false
  });
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      governorate: json['governorate'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}