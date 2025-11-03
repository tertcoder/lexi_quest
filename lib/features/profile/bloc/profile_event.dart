import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/profile/data/models/user_profile_model.dart';

/// Profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load profile event
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Update profile event
class UpdateProfile extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfile({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Upload avatar event
class UploadAvatar extends ProfileEvent {
  final String filePath;

  const UploadAvatar({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Update streak event
class UpdateStreak extends ProfileEvent {
  const UpdateStreak();
}

/// Add XP event (for task completion)
class AddXp extends ProfileEvent {
  final int xpAmount;
  final String? taskName;
  final String? projectName;

  const AddXp({
    required this.xpAmount,
    this.taskName,
    this.projectName,
  });

  @override
  List<Object?> get props => [xpAmount, taskName, projectName];
}
