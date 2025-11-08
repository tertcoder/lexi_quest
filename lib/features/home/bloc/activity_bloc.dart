import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexi_quest/features/home/bloc/activity_event.dart';
import 'package:lexi_quest/features/home/bloc/activity_state.dart';
import 'package:lexi_quest/features/home/data/repositories/activity_repository.dart';

/// Activity BLoC
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc({ActivityRepository? activityRepository})
      : _activityRepository = activityRepository ?? ActivityRepository(),
        super(const ActivityInitial()) {
    on<LoadActivities>(_onLoadActivities);
  }

  /// Handle load activities
  Future<void> _onLoadActivities(
    LoadActivities event,
    Emitter<ActivityState> emit,
  ) async {
    emit(const ActivityLoading());
    try {
      final activities = await _activityRepository.getUserActivities(limit: 5);
      emit(ActivityLoaded(activities: activities));
    } catch (e) {
      emit(ActivityError(message: e.toString()));
    }
  }
}
