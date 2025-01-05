import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/place.dart';
import '../data/repositories/PlaceRepository.dart';

class PlaceCard extends StatefulWidget {
  final Place place;
  final Function(Place)? onFavoriteChanged;

  const PlaceCard({
    super.key,
    required this.place,
    this.onFavoriteChanged,
  });

  @override
  PlaceCardState createState() => PlaceCardState();
}

class PlaceCardState extends State<PlaceCard> {
  late PlaceRepository _repository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final prefs = await SharedPreferences.getInstance();
    _repository = PlaceRepository(prefs);
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await _repository.isFavorite(widget.place.id);
    if (mounted && isFavorite != widget.place.isFavorite) {
      setState(() {
        widget.place.isFavorite = isFavorite;
      });
    }
  }

  void _showSnackBar(bool isFavorite) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            isFavorite
                ? '${widget.place.name} added to favorites'
                : '${widget.place.name} removed from favorites',
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          _toggleFavorite(showSnackBar: false);
        },
      ),
      backgroundColor: isFavorite ? Colors.green : Colors.grey[800],
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _toggleFavorite({bool showSnackBar = true}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _repository.toggleFavorite(widget.place.id);
      setState(() {
        widget.place.isFavorite = !widget.place.isFavorite;
      });
      if (showSnackBar) {
        _showSnackBar(widget.place.isFavorite);
      }
      widget.onFavoriteChanged?.call(widget.place);
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildImage(),
              ),
              _buildContent(),
            ],
          ),
          _buildFavoriteButton(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      color: Colors.grey[300],
      child: widget.place.imageUrl != null
          ? Image.asset(
        widget.place.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
      )
          : const Icon(Icons.image, size: 40),
    );
  }


  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.place.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.place.governorate,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          if (widget.place.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.place.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleFavorite(),
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(
              widget.place.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.place.isFavorite ? Colors.red : Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}