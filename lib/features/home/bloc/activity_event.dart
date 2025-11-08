import 'package:equatable/equatable.dart';

/// Activity events
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

/// Load activities event
class LoadActivities extends ActivityEvent {
  const LoadActivities();
}
