import 'package:equatable/equatable.dart';

/// Activity states
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ActivityInitial extends ActivityState {
  const ActivityInitial();
}

/// Loading state
class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

/// Loaded state
class ActivityLoaded extends ActivityState {
  final List<Map<String, dynamic>> activities;

  const ActivityLoaded({required this.activities});

  @override
  List<Object?> get props => [activities];
}

/// Error state
class ActivityError extends ActivityState {
  final String message;

  const ActivityError({required this.message});

  @override
  List<Object?> get props => [message];
}
