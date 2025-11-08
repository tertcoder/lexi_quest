import 'package:equatable/equatable.dart';
import 'package:lexi_quest/features/annotation/data/models/annotation_model.dart';

/// Annotation events
abstract class AnnotationEvent extends Equatable {
  const AnnotationEvent();

  @override
  List<Object?> get props => [];
}

/// Load annotations event
class LoadAnnotations extends AnnotationEvent {
  final AnnotationType? type;
  final int limit;

  const LoadAnnotations({this.type, this.limit = 20});

  @override
  List<Object?> get props => [type, limit];
}

/// Submit annotation event
class SubmitAnnotation extends AnnotationEvent {
  final String annotationId;
  final String? projectId;
  final Map<String, dynamic> data;
  final int xpEarned;

  const SubmitAnnotation({
    required this.annotationId,
    this.projectId,
    required this.data,
    required this.xpEarned,
  });

  @override
  List<Object?> get props => [annotationId, projectId, data, xpEarned];
}

/// Upload image event
class UploadAnnotationImage extends AnnotationEvent {
  final String filePath;

  const UploadAnnotationImage({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Upload audio event
class UploadAnnotationAudio extends AnnotationEvent {
  final String filePath;

  const UploadAnnotationAudio({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Create annotation event
class CreateAnnotation extends AnnotationEvent {
  final AnnotationModel annotation;

  const CreateAnnotation({required this.annotation});

  @override
  List<Object?> get props => [annotation];
}

/// Load available annotations for a project event
class LoadAvailableAnnotationsForProject extends AnnotationEvent {
  final String projectId;
  final AnnotationType type;
  final int limit;

  const LoadAvailableAnnotationsForProject({
    required this.projectId,
    required this.type,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [projectId, type, limit];
}

/// Load annotations from project tasks (for annotation screens)
class LoadAnnotationsFromProjectTasks extends AnnotationEvent {
  final String projectId;
  final AnnotationType type;

  const LoadAnnotationsFromProjectTasks({
    required this.projectId,
    required this.type,
  });

  @override
  List<Object?> get props => [projectId, type];
}

/// Load all unannotated project tasks (for home page quick actions)
class LoadAllUnannotatedProjectTasks extends AnnotationEvent {
  final AnnotationType type;
  final int limit;

  const LoadAllUnannotatedProjectTasks({
    required this.type,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [type, limit];
}
