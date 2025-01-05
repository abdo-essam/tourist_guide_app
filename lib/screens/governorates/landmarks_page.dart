import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_themes.dart';
import '../../data/models/governorate.dart';
import '../../data/models/landmark.dart';

class LandmarksPage extends StatelessWidget {
  final Governorate governorate;

  const LandmarksPage({
    super.key,
    required this.governorate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildLandmarksList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(governorate.name),
        background: Image.asset(
          governorate.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLandmarksList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => _LandmarkCard(landmark: governorate.landmarks[index]),
        childCount: governorate.landmarks.length,
      ),
    );
  }
}

class _LandmarkCard extends StatelessWidget {
  final Landmark landmark;

  const _LandmarkCard({required this.landmark});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showLandmarkDetails(context),
        child: Row(
          children: [
            Image.asset(
              landmark.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      landmark.name,
                      style: AppTextTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      landmark.description,
                      style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          landmark.rating.toString(),
                          style: AppTextTheme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.location_on, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          landmark.location,
                          style: AppTextTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLandmarkDetails(BuildContext context) {
    // Implement landmark details page navigation
  }
}