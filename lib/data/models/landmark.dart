class Landmark {
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String location;

  Landmark({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
    required this.location,
  });
}