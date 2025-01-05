import '../models/governorate.dart';
import '../models/landmark.dart';

class GovernorateRepository {
  static List<Governorate> getGovernorates() {
    return [
      Governorate(
        name: 'Cairo',
        description: 'The capital of Egypt and largest city in the Arab world.',
        imageUrl: 'assets/images/cairo.png',
        landmarks: [
          Landmark(
            name: 'Egyptian Museum',
            description: 'Home to an extensive collection of ancient Egyptian antiquities.',
            imageUrl: 'assets/images/museum.png',
            rating: 4.8,
            location: 'Tahrir Square',
          ),
          Landmark(
            name: 'Khan el-Khalili',
            description: 'A famous bazaar and souq in Cairo\'s historic district.',
            imageUrl: 'assets/images/khan_khalili.png',
            rating: 4.6,
            location: 'El-Gamaleya',
          ),
        ],
      ),
    ];
  }
}