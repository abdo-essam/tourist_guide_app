import 'landmark.dart';

class Governorate {
  final String name;
  final String description;
  final String imageUrl;
  final List<Landmark> landmarks;

  Governorate({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.landmarks,
  });
}