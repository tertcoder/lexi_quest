import 'package:equatable/equatable.dart';
import '../data/models/annotation_task_model.dart';
import '../data/models/completed_annotation_model.dart';

/// Base class for annotation states
abstract class AnnotationState extends Equatable {
  const AnnotationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AnnotationInitial extends AnnotationState {
  const AnnotationInitial();
}

/// Loading state
class AnnotationLoading extends AnnotationState {
  const AnnotationLoading();
}

/// State when annotation tasks are loaded
class AnnotationTasksLoaded extends AnnotationState {
  final List<AnnotationTask> tasks;
  final List<CompletedAnnotation> completedAnnotations;

  const AnnotationTasksLoaded({
    required this.tasks,
    required this.completedAnnotations,
  });

  @override
  List<Object?> get props => [tasks, completedAnnotations];
}

/// State when actively working on an annotation task
class AnnotationInProgress extends AnnotationState {
  final AnnotationTask currentTask;
  final List<AnnotationLabel> currentLabels;
  final List<AnnotationTask> availableTasks;
  final List<CompletedAnnotation> completedAnnotations;

  const AnnotationInProgress({
    required this.currentTask,
    required this.currentLabels,
    required this.availableTasks,
    required this.completedAnnotations,
  });

  @override
  List<Object?> get props => [
    currentTask,
    currentLabels,
    availableTasks,
    completedAnnotations,
  ];

  AnnotationInProgress copyWith({
    AnnotationTask? currentTask,
    List<AnnotationLabel>? currentLabels,
    List<AnnotationTask>? availableTasks,
    List<CompletedAnnotation>? completedAnnotations,
  }) {
    return AnnotationInProgress(
      currentTask: currentTask ?? this.currentTask,
      currentLabels: currentLabels ?? this.currentLabels,
      availableTasks: availableTasks ?? this.availableTasks,
      completedAnnotations: completedAnnotations ?? this.completedAnnotations,
    );
  }
}

/// State when annotation is submitted successfully
class AnnotationSubmitted extends AnnotationState {
  final CompletedAnnotation submittedAnnotation;
  final List<AnnotationTask> availableTasks;
  final List<CompletedAnnotation> completedAnnotations;

  const AnnotationSubmitted({
    required this.submittedAnnotation,
    required this.availableTasks,
    required this.completedAnnotations,
  });

  @override
  List<Object?> get props => [
    submittedAnnotation,
    availableTasks,
    completedAnnotations,
  ];
}

/// Error state
class AnnotationError extends AnnotationState {
  final String message;

  const AnnotationError(this.message);

  @override
  List<Object?> get props => [message];
}
