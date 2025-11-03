import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/profile/data/models/user_profile_model.dart';

/// Profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Loaded state
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Error state
class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Level up state (triggers celebration)
class ProfileLevelUp extends ProfileState {
  final UserProfile profile;
  final int oldLevel;
  final int newLevel;
  final int xpEarned;
  final String? taskName;
  final String? projectName;

  const ProfileLevelUp({
    required this.profile,
    required this.oldLevel,
    required this.newLevel,
    required this.xpEarned,
    this.taskName,
    this.projectName,
  });

  @override
  List<Object?> get props => [profile, oldLevel, newLevel, xpEarned, taskName, projectName];
}

/// Task completed state (triggers celebration)
class ProfileTaskCompleted extends ProfileState {
  final UserProfile profile;
  final int xpEarned;
  final String? taskName;
  final String? projectName;

  const ProfileTaskCompleted({
    required this.profile,
    required this.xpEarned,
    this.taskName,
    this.projectName,
  });

  @override
  List<Object?> get props => [profile, xpEarned, taskName, projectName];
}
