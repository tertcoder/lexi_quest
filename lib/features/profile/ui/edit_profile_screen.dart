import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/core/theme/app_fonts.dart';
import 'package:lexi_quest/core/widgets/app_input_field.dart';
import 'package:lexi_quest/features/profile/bloc/profile_bloc.dart';
import 'package:lexi_quest/features/profile/bloc/profile_event.dart';
import 'package:lexi_quest/features/profile/bloc/profile_state.dart';
import 'package:lexi_quest/features/profile/data/models/user_profile_model.dart';
import 'package:lexi_quest/features/profile/data/repositories/user_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _newAvatarUrl;
  bool _isUploading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() => _isUploading = true);

      try {
        final userRepository = UserRepository();
        final avatarUrl = await userRepository.uploadAvatar(image.path);

        setState(() {
          _newAvatarUrl = avatarUrl;
          _isUploading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar uploaded successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        setState(() => _isUploading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload avatar: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _saveProfile(
    BuildContext context,
    UserProfile currentProfile,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProfile = UserProfile(
      userId: currentProfile.userId,
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      avatarUrl: _newAvatarUrl ?? currentProfile.avatarUrl,
      totalXp: currentProfile.totalXp,
      level: currentProfile.level,
      currentLevelXp: currentProfile.currentLevelXp,
      nextLevelXp: currentProfile.nextLevelXp,
      streak: currentProfile.streak,
      annotationsCompleted: currentProfile.annotationsCompleted,
      badges: currentProfile.badges,
      joinedAt: currentProfile.joinedAt,
      lastActiveAt: DateTime.now(),
    );

    context.read<ProfileBloc>().add(UpdateProfile(profile: updatedProfile));

    // Wait for update to complete
    await context.read<ProfileBloc>().stream.firstWhere(
      (state) => state is ProfileLoaded || state is ProfileError,
    );

    if (mounted && context.read<ProfileBloc>().state is ProfileLoaded) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.secondaryGreen500,
            ),
          );
          context.pop();
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.secondaryRed500,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          // Initialize controllers with current data
          if (_usernameController.text.isEmpty) {
            _usernameController.text = state.profile.username;
            _emailController.text = state.profile.email;
          }

          final isLoading = false;

          return Scaffold(
            backgroundColor: AppColors.surface,
            appBar: AppBar(
              backgroundColor: AppColors.primaryIndigo600,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.onPrimary),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Edit Profile',
                style: AppFonts.titleLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Avatar Section
                      Center(
                        child: GestureDetector(
                          onTap: () => _pickAvatar(context),
                          child: Stack(
                            children: [
                              _isUploading
                                  ? const CircleAvatar(
                                    radius: 60,
                                    backgroundColor: AppColors.primaryIndigo600,
                                    child: CircularProgressIndicator(
                                      color: AppColors.onPrimary,
                                    ),
                                  )
                                  : CircleAvatar(
                                    radius: 60,
                                    backgroundColor: AppColors.primaryIndigo600,
                                    backgroundImage:
                                        _newAvatarUrl != null
                                            ? NetworkImage(_newAvatarUrl!)
                                            : (state.profile.avatarUrl != null
                                                ? NetworkImage(
                                                  state.profile.avatarUrl!,
                                                )
                                                : null),
                                    child:
                                        (_newAvatarUrl == null &&
                                                state.profile.avatarUrl == null)
                                            ? Text(
                                              state.profile.username[0]
                                                  .toUpperCase(),
                                              style: AppFonts.headlineLarge
                                                  .copyWith(
                                                    color: AppColors.onPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            )
                                            : null,
                                  ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryIndigo600,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: AppColors.onPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Username Field
                      Text(
                        'Username',
                        style: AppFonts.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppInputField(
                        controller: _usernameController,
                        placeholder: 'Username',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      Text(
                        'Email',
                        style: AppFonts.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppInputField(
                        controller: _emailController,
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () => _saveProfile(context, state.profile),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryIndigo600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isLoading ? 'Saving...' : 'Save Changes',
                            style: AppFonts.buttonText.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.primaryIndigo600,
            title: const Text('Edit Profile'),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
