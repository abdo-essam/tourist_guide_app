import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_themes.dart';
import '../../data/models/governorate.dart';
import '../../data/repositories/GovernorateRepository.dart';
import 'landmarks_page.dart';

class GovernmentsPage extends StatelessWidget {
  const GovernmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final governorates = GovernorateRepository.getGovernorates();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: governorates.length,
      itemBuilder: (context, index) {
        return _GovernorateCard(governorate: governorates[index]);
      },
    );
  }
}

class _GovernorateCard extends StatelessWidget {
  final Governorate governorate;

  const _GovernorateCard({required this.governorate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToLandmarks(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      governorate.imageUrl,
      height: 150,
      fit: BoxFit.cover,
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            governorate.name,
            style: AppTextTheme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            governorate.description,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                '${governorate.landmarks.length} Landmarks',
                style: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToLandmarks(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouter.landMark,
      arguments: {'governorate': governorate},
    );
  }
}