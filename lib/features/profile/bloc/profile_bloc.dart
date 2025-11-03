import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/profile/bloc/profile_event.dart';
import 'package:lexi_quest/features/profile/bloc/profile_state.dart';
import 'package:lexi_quest/features/profile/data/models/user_profile_model.dart';
import 'package:lexi_quest/features/profile/data/repositories/user_repository.dart';

/// Profile BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository(),
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadAvatar>(_onUploadAvatar);
    on<UpdateStreak>(_onUpdateStreak);
    on<AddXp>(_onAddXp);
  }

  /// Handle load profile
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _userRepository.getCurrentUserProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handle update profile
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      await _userRepository.updateUserProfile(event.profile);
      emit(ProfileLoaded(profile: event.profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handle upload avatar
  Future<void> _onUploadAvatar(
    UploadAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(const ProfileLoading());
        
        final avatarUrl = await _userRepository.uploadAvatar(event.filePath);
        final updatedProfile = UserProfile(
          userId: currentState.profile.userId,
          username: currentState.profile.username,
          email: currentState.profile.email,
          avatarUrl: avatarUrl,
          totalXp: currentState.profile.totalXp,
          level: currentState.profile.level,
          currentLevelXp: currentState.profile.currentLevelXp,
          nextLevelXp: currentState.profile.nextLevelXp,
          streak: currentState.profile.streak,
          annotationsCompleted: currentState.profile.annotationsCompleted,
          badges: currentState.profile.badges,
          joinedAt: currentState.profile.joinedAt,
          lastActiveAt: currentState.profile.lastActiveAt,
        );
        
        await _userRepository.updateUserProfile(updatedProfile);
        emit(ProfileLoaded(profile: updatedProfile));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handle update streak
  Future<void> _onUpdateStreak(
    UpdateStreak event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _userRepository.updateStreak();
      add(const LoadProfile());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Handle add XP (with level up detection)
  Future<void> _onAddXp(
    AddXp event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        final oldProfile = currentState.profile;
        final oldLevel = oldProfile.level;
        
        // Calculate new XP and level
        final newTotalXp = oldProfile.totalXp + event.xpAmount;
        final newLevel = _calculateLevel(newTotalXp);
        final xpForCurrentLevel = _calculateXpForLevel(newLevel);
        final xpForNextLevel = _calculateXpForLevel(newLevel + 1);
        final newCurrentLevelXp = newTotalXp - xpForCurrentLevel;
        final newNextLevelXp = xpForNextLevel - xpForCurrentLevel;
        
        // Create updated profile
        final updatedProfile = UserProfile(
          userId: oldProfile.userId,
          username: oldProfile.username,
          email: oldProfile.email,
          avatarUrl: oldProfile.avatarUrl,
          totalXp: newTotalXp,
          level: newLevel,
          currentLevelXp: newCurrentLevelXp,
          nextLevelXp: newNextLevelXp,
          streak: oldProfile.streak,
          annotationsCompleted: oldProfile.annotationsCompleted + 1,
          badges: oldProfile.badges,
          joinedAt: oldProfile.joinedAt,
          lastActiveAt: DateTime.now(),
        );
        
        // Update in database
        await _userRepository.updateUserProfile(updatedProfile);
        
        // Emit appropriate state
        if (newLevel > oldLevel) {
          // Level up occurred!
          emit(ProfileLevelUp(
            profile: updatedProfile,
            oldLevel: oldLevel,
            newLevel: newLevel,
            xpEarned: event.xpAmount,
            taskName: event.taskName,
            projectName: event.projectName,
          ));
        } else {
          // Just task completion
          emit(ProfileTaskCompleted(
            profile: updatedProfile,
            xpEarned: event.xpAmount,
            taskName: event.taskName,
            projectName: event.projectName,
          ));
        }
        
        // Then emit loaded state
        emit(ProfileLoaded(profile: updatedProfile));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  /// Calculate level from total XP
  int _calculateLevel(int totalXp) {
    if (totalXp == 0) return 1;
    
    int level = 1;
    while (_calculateXpForLevel(level + 1) <= totalXp) {
      level++;
    }
    return level;
  }

  /// Calculate total XP required to reach a specific level
  int _calculateXpForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    return (100 * (targetLevel - 1) * (targetLevel - 1) * 0.5).round();
  }
}
