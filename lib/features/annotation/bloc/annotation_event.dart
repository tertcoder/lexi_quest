import 'package:equatable/equatable.dart';
import '../data/models/annotation_task_model.dart';
import '../data/models/completed_annotation_model.dart';

/// Base class for annotation events
abstract class AnnotationEvent extends Equatable {
  const AnnotationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load available annotation tasks
class LoadAnnotationTasks extends AnnotationEvent {
  const LoadAnnotationTasks();
}

/// Event to load completed annotations
class LoadCompletedAnnotations extends AnnotationEvent {
  const LoadCompletedAnnotations();
}

/// Event to start working on a specific task
class StartAnnotationTask extends AnnotationEvent {
  final AnnotationTask task;

  const StartAnnotationTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event to add an annotation label
class AddAnnotationLabel extends AnnotationEvent {
  final AnnotationLabel label;

  const AddAnnotationLabel(this.label);

  @override
  List<Object?> get props => [label];
}

/// Event to remove an annotation label
class RemoveAnnotationLabel extends AnnotationEvent {
  final String labelId;

  const RemoveAnnotationLabel(this.labelId);

  @override
  List<Object?> get props => [labelId];
}

/// Event to submit completed annotation
class SubmitAnnotation extends AnnotationEvent {
  final String taskId;
  final List<AnnotationLabel> labels;

  const SubmitAnnotation({required this.taskId, required this.labels});

  @override
  List<Object?> get props => [taskId, labels];
}

/// Event to clear current annotation work
class ClearCurrentAnnotation extends AnnotationEvent {
  const ClearCurrentAnnotation();
}
