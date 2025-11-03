import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

/// Annotation states
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

/// Loaded state (multiple annotations)
class AnnotationsLoaded extends AnnotationState {
  final List<AnnotationModel> annotations;

  const AnnotationsLoaded({required this.annotations});

  @override
  List<Object?> get props => [annotations];
}

/// Loaded state (single annotation) - alias for consistency
class AnnotationLoaded extends AnnotationState {
  final List<AnnotationModel> annotations;

  const AnnotationLoaded({required this.annotations});

  @override
  List<Object?> get props => [annotations];
}

/// Created state
class AnnotationCreated extends AnnotationState {
  final AnnotationModel annotation;

  const AnnotationCreated({required this.annotation});

  @override
  List<Object?> get props => [annotation];
}

/// Submitted state
class AnnotationSubmitted extends AnnotationState {
  final int xpEarned;

  const AnnotationSubmitted({required this.xpEarned});

  @override
  List<Object?> get props => [xpEarned];
}

/// File uploaded state
class FileUploaded extends AnnotationState {
  final String url;

  const FileUploaded({required this.url});

  @override
  List<Object?> get props => [url];
}

/// Error state
class AnnotationError extends AnnotationState {
  final String message;

  const AnnotationError({required this.message});

  @override
  List<Object?> get props => [message];
}
