import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_themes.dart';
import '../../data/models/user.dart';
import '../../data/repositories/AuthRepository.dart';
import '../../widgets/profile_info_tile.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthRepository _authRepository;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authRepository = AuthRepository(prefs);
      final user = _authRepository.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to load profile: ${e.toString()}');
    }
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load profile'),
              ElevatedButton(
                onPressed: _initializeData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _initializeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildProfileInfo()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          Text(
            _user!.fullName,
            style: AppTextTheme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _user!.email,
            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 4,
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage:
            _user!.avatarUrl != null ? AssetImage(_user!.avatarUrl!) : null,
            child: _user!.avatarUrl == null
                ? Text(
              _user!.fullName[0],
              style: AppTextTheme.textTheme.displayLarge?.copyWith(
                color: AppColors.primary,
              ),
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTextTheme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ProfileInfoTile(
          title: 'Full Name',
          value: _user!.fullName,
          icon: Icons.person,
        ),
        ProfileInfoTile(
          title: 'Email',
          value: _user!.email,
          icon: Icons.email,
        ),
        ProfileInfoTile(
          title: 'Phone Number',
          value: _user!.phoneNumber ?? 'Not provided',
          icon: Icons.phone,
        ),
      ],
    );
  }

}
