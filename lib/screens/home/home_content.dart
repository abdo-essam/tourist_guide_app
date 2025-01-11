import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/PlaceRepository.dart';
import '../../data/models/place.dart';
import '../../widgets/place_card.dart';
import '../../widgets/section_title.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late PlaceRepository _placeRepository;
  List<Place>? _suggestedPlaces;
  List<Place>? _popularPlaces;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _placeRepository = PlaceRepository(prefs);
      await _loadPlaces();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPlaces() async {
    setState(() => _isLoading = true);
    try {
      final suggestedPlaces = await _placeRepository.getSuggestedPlaces();
      final popularPlaces = await _placeRepository.getPopularPlaces();

      setState(() {
        _suggestedPlaces = suggestedPlaces;
        _popularPlaces = popularPlaces;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleFavoriteChanged(Place place) {
    _loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlaces,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPlaces, 
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSuggestedPlaces(),
                  _buildPopularPlaces(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedPlaces() {
    if (_suggestedPlaces == null || _suggestedPlaces!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Suggested Places'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: _suggestedPlaces!.length,
          itemBuilder: (context, index) {
            return PlaceCard(
              place: _suggestedPlaces![index],
              onFavoriteChanged: _handleFavoriteChanged,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPopularPlaces() {
    if (_popularPlaces == null || _popularPlaces!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Popular Places'),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _popularPlaces!.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200, // Add fixed width for better layout
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: PlaceCard(
                    place: _popularPlaces![index],
                    onFavoriteChanged: _handleFavoriteChanged,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}