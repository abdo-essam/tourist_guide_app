import 'package:shared_preferences/shared_preferences.dart';
import '../models/place.dart';

class PlaceRepository {
  static const String _favoritesKey = 'favorites';
  final SharedPreferences _prefs;

  PlaceRepository(this._prefs);

  static final List<Place> _allPlaces = [
    Place(
      id: '1',
      name: 'Pyramids of Giza',
      governorate: 'Giza',
      imageUrl: 'assets/images/pyramids.png',
      description: 'Ancient Egyptian pyramids complex',
    ),
    Place(
      id: '2',
      name: 'Karnak Temple',
      governorate: 'Luxor',
      imageUrl: 'assets/images/karnak.png',
      description: 'Ancient Egyptian temple complex',
    ),
    Place(
      id: '3',
      name: 'Alexandria Library',
      governorate: 'Alexandria',
      imageUrl: 'assets/images/library.png',
      description: 'Modern library and cultural center',
    ),
    Place(
      id: '4',
      name: 'Valley of the Kings',
      governorate: 'Luxor',
      imageUrl: 'assets/images/valley_kings.png',
      description: 'Ancient Egyptian royal tombs',
    ),
    Place(
      id: '5',
      name: 'Egyptian Museum',
      governorate: 'Cairo',
      imageUrl: 'assets/images/museum.png',
      description: 'Museum of ancient Egyptian antiquities',
    ),
    Place(
      id: '6',
      name: 'Abu Simbel',
      governorate: 'Aswan',
      imageUrl: 'assets/images/abu_simbel.png',
      description:
          'Abu Simbel is a historic site comprising two massive rock-cut temples in the village of Abu Simbel',
    ),
    Place(
      id: '7',
      name: 'Siwa Oasis',
      governorate: 'Matrouh',
      imageUrl: 'assets/images/siwa.png',
      description: 'Siwa Oasis is a historic site comprising two massive rock-cut',
    ),
    Place(
      id: '8',
      name: 'Citadel of Qaitbay',
      governorate: 'Alexandria',
      imageUrl: 'assets/images/citadel.png',
    description: 'The Citadel of Qaitbay is a 15th-century defensive fortress located on the Mediterranean sea coast',
    ),
  ];

  Future<List<Place>> getSuggestedPlaces() async {
    final favorites = await _getFavoriteIds();
    return _allPlaces.sublist(0, 4).map((place) {
      place.isFavorite = favorites.contains(place.id);
      return place;
    }).toList();
  }

  Future<List<Place>> getPopularPlaces() async {
    final favorites = await _getFavoriteIds();
    return _allPlaces.sublist(4).map((place) {
      place.isFavorite = favorites.contains(place.id);
      return place;
    }).toList();
  }

  Future<List<Place>> getFavoritePlaces() async {
    final favorites = await _getFavoriteIds();
    return _allPlaces
        .where((place) => favorites.contains(place.id))
        .map((place) {
      place.isFavorite = true;
      return place;
    }).toList();
  }

  Future<List<String>> _getFavoriteIds() async {
    return _prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> toggleFavorite(String placeId) async {
    final favorites = await _getFavoriteIds();
    if (favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }
    await _prefs.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String placeId) async {
    final favorites = await _getFavoriteIds();
    return favorites.contains(placeId);
  }
}
