import 'package:flutter_bloc/flutter_bloc.dart';
import 'annotation_event.dart';
import 'annotation_state.dart';
import '../data/repositories/annotation_demo_data.dart';
import '../data/models/annotation_task_model.dart';
import '../data/models/completed_annotation_model.dart';

/// Bloc for managing annotation state
class AnnotationBloc extends Bloc<AnnotationEvent, AnnotationState> {
  AnnotationBloc() : super(const AnnotationInitial()) {
    on<LoadAnnotationTasks>(_onLoadAnnotationTasks);
    on<LoadCompletedAnnotations>(_onLoadCompletedAnnotations);
    on<StartAnnotationTask>(_onStartAnnotationTask);
    on<AddAnnotationLabel>(_onAddAnnotationLabel);
    on<RemoveAnnotationLabel>(_onRemoveAnnotationLabel);
    on<SubmitAnnotation>(_onSubmitAnnotation);
    on<ClearCurrentAnnotation>(_onClearCurrentAnnotation);
  }

  Future<void> _onLoadAnnotationTasks(
    LoadAnnotationTasks event,
    Emitter<AnnotationState> emit,
  ) async {
    emit(const AnnotationLoading());

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final tasks = AnnotationDemoData.demoTasks;
      final completedAnnotations = AnnotationDemoData.demoCompletedAnnotations;

      emit(
        AnnotationTasksLoaded(
          tasks: tasks,
          completedAnnotations: completedAnnotations,
        ),
      );
    } catch (e) {
      emit(AnnotationError('Failed to load annotation tasks: $e'));
    }
  }

  Future<void> _onLoadCompletedAnnotations(
    LoadCompletedAnnotations event,
    Emitter<AnnotationState> emit,
  ) async {
    if (state is AnnotationTasksLoaded) {
      final currentState = state as AnnotationTasksLoaded;
      final completedAnnotations = AnnotationDemoData.demoCompletedAnnotations;

      emit(
        AnnotationTasksLoaded(
          tasks: currentState.tasks,
          completedAnnotations: completedAnnotations,
        ),
      );
    }
  }

  Future<void> _onStartAnnotationTask(
    StartAnnotationTask event,
    Emitter<AnnotationState> emit,
  ) async {
    if (state is AnnotationTasksLoaded) {
      final currentState = state as AnnotationTasksLoaded;

      emit(
        AnnotationInProgress(
          currentTask: event.task,
          currentLabels: [],
          availableTasks: currentState.tasks,
          completedAnnotations: currentState.completedAnnotations,
        ),
      );
    }
  }

  void _onAddAnnotationLabel(
    AddAnnotationLabel event,
    Emitter<AnnotationState> emit,
  ) {
    if (state is AnnotationInProgress) {
      final currentState = state as AnnotationInProgress;
      final updatedLabels = List<AnnotationLabel>.from(
        currentState.currentLabels,
      )..add(event.label);

      emit(currentState.copyWith(currentLabels: updatedLabels));
    }
  }

  void _onRemoveAnnotationLabel(
    RemoveAnnotationLabel event,
    Emitter<AnnotationState> emit,
  ) {
    if (state is AnnotationInProgress) {
      final currentState = state as AnnotationInProgress;
      final updatedLabels =
          currentState.currentLabels
              .where((label) => label.id != event.labelId)
              .toList();

      emit(currentState.copyWith(currentLabels: updatedLabels));
    }
  }

  Future<void> _onSubmitAnnotation(
    SubmitAnnotation event,
    Emitter<AnnotationState> emit,
  ) async {
    if (state is AnnotationInProgress) {
      final currentState = state as AnnotationInProgress;

      try {
        // Simulate submission delay
        await Future.delayed(const Duration(milliseconds: 1000));

        // Create completed annotation
        final completedAnnotation = CompletedAnnotation(
          id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
          taskId: event.taskId,
          userId: 'user_1',
          title: currentState.currentTask.title,
          description: currentState.currentTask.content,
          type: currentState.currentTask.type,
          labels: event.labels,
          completedAt: DateTime.now(),
          xpEarned: currentState.currentTask.xpReward ?? 0,
          accuracy:
              0.85 + (event.labels.length * 0.02), // Mock accuracy calculation
          labelsAdded: event.labels.length,
          timeSpent: 15 + (event.labels.length * 5), // Mock time calculation
        );

        // Update task status
        final updatedTasks =
            currentState.availableTasks.map((task) {
              if (task.id == event.taskId) {
                return task.copyWith(status: TaskStatus.completed);
              }
              return task;
            }).toList();

        final updatedCompletedAnnotations = [
          ...currentState.completedAnnotations,
          completedAnnotation,
        ];

        emit(
          AnnotationSubmitted(
            submittedAnnotation: completedAnnotation,
            availableTasks: updatedTasks,
            completedAnnotations: updatedCompletedAnnotations,
          ),
        );

        // Return to tasks list after a short delay
        await Future.delayed(const Duration(seconds: 2));
        emit(
          AnnotationTasksLoaded(
            tasks: updatedTasks,
            completedAnnotations: updatedCompletedAnnotations,
          ),
        );
      } catch (e) {
        emit(AnnotationError('Failed to submit annotation: $e'));
      }
    }
  }

  void _onClearCurrentAnnotation(
    ClearCurrentAnnotation event,
    Emitter<AnnotationState> emit,
  ) {
    if (state is AnnotationInProgress) {
      final currentState = state as AnnotationInProgress;

      emit(
        AnnotationTasksLoaded(
          tasks: currentState.availableTasks,
          completedAnnotations: currentState.completedAnnotations,
        ),
      );
    }
  }
}
